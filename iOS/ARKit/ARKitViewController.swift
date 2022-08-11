//
//  ARKitViewController.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/7/28.
//

import ARKit
import SnapKit
import SwiftUI
import UIKit

class ARKitViewController: UIViewController {
    private var visContext = VisualizationContext()

    private let trackingSwitch = UISwitch()
    private let trackingLabel = UILabel()

    override func loadView() {
        view = ARSCNView()
    }

    var sceneView: ARSCNView {
        view as! ARSCNView
    }

    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        sceneView.session
    }

    // MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.session.delegate = self

        // Debug
        trackingLabel.text = "Tracking: "
        trackingSwitch.isOn = true
        view.addSubview(trackingLabel)
        view.addSubview(trackingSwitch)
        trackingLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        trackingSwitch.snp.makeConstraints { make in
            make.leading.equalTo(trackingLabel.snp.trailing)
            make.centerY.equalTo(trackingLabel)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Prevent the screen from being dimmed to avoid interrupting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true

        setVisualizationConfiguration(.example2)
    }

    // MARK: - Session management

    private func generateConfiguration(trackedImages: [ARReferenceImage] = [], trackedObjects: [ARReferenceObject] = []) -> ARConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        // Image tracking
        let referenceImages = Set(trackedImages)
        configuration.detectionImages = referenceImages
        // Enable auto scale estimation. But, DO NOT change the image size during tracking!
        configuration.automaticImageScaleEstimationEnabled = true
        configuration.maximumNumberOfTrackedImages = referenceImages.count

        // Object tracking
        configuration.detectionObjects = Set(trackedObjects)
        return configuration
    }

    /// Creates a new AR configuration to run on the `session`.
    func resetTracking(trackedImages: [ARReferenceImage] = [], trackedObjects: [ARReferenceObject] = []) {
        let configuration = generateConfiguration(trackedImages: trackedImages, trackedObjects: trackedObjects)
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    // MARK: - Widget position

    private func updateWidgetTransform(conf: ImageTrackingConfiguration, nodePair: VisualizationContext.NodePair, imageAnchor: ARImageAnchor) {
        nodePair._node.position = conf.relativePosition + conf.positionOffset

        guard let plane = nodePair.node.geometry as? SCNPlane else {
            fatalErrorDebug()
            return
        }

        let targetImageSize = imageAnchor.referenceImage.physicalSize * imageAnchor.estimatedScaleFactor
        var xOffset: CGFloat
        var yOffset: CGFloat
        switch conf.relativeAnchorPoint {
        case .bottom:
            xOffset = -plane.width / 2
            yOffset = -targetImageSize.height / 2 - plane.height / 2
        case .center:
            xOffset = -plane.width / 2
            yOffset = 0
        case .leading:
            xOffset = -targetImageSize.width / 2 - plane.width
            yOffset = 0
        case .top:
            xOffset = -plane.width / 2
            yOffset = targetImageSize.height / 2 + plane.height / 2
        case .trailing:
            xOffset = targetImageSize.width / 2
            yOffset = 0
        }
        nodePair.node.pivot = SCNMatrix4Identity
            .translated(x: Float(-xOffset), y: Float(-yOffset), z: 0)
            .rotated(angle: Float.pi / 2, axis: SCNVector3(1, 0, 0))
        nodePair.node.setWorldTransform(nodePair._node.worldTransform)
    }
}

// MARK: - Visualization Configuration

extension ARKitViewController {
    func setVisualizationConfiguration(_ conf: VisualizationConfiguration) {
        visContext.reset()

        visContext.visConfiguration = conf
        visContext.processVisualizationConfiguration { [weak self] result in
            if let self = self {
                DispatchQueue.main.async {
                    self.resetTracking(trackedImages: result.referenceImages, trackedObjects: result.referenceObjects)
                }
            }
        }
    }
}

// MARK: - ARSCNViewDelegate

extension ARKitViewController: ARSCNViewDelegate {
    func renderer(_: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor {
            printDebug("New ARImageAnchor Added: \(imageAnchor.referenceImage.name ?? "No name provided.")")

            guard let conf = visContext.visConfiguration?.findImageConfiguration(anchor: imageAnchor) else {
                fatalErrorDebug("Cannot find corresponding image configuration for anchor: \(imageAnchor)")
                return
            }

            imageAnchor.addPlaneNode(on: node, color: UIColor.blue.withAlphaComponent(0.5))

            let nodePair = VisualizationContext.NodePair()

            visContext.set(nodePair: nodePair, for: conf.imageURL)

            DispatchQueue.main.async {
                nodePair.node.geometry = {
                    let plane = SCNPlane()
                    plane.width = 0.4
                    plane.height = 0.3
                    return plane
                }()
                let widgetViewController = WidgetExampleViewController()
                nodePair.widgetViewController = widgetViewController

                let material: SCNMaterial = {
                    let material = SCNMaterial()
                    material.diffuse.contents = widgetViewController.view
                    return material
                }()
                nodePair.node.geometry?.materials = [material]

                node.addChildNode(nodePair._node)
                self.sceneView.scene.rootNode.addChildNode(nodePair.node)

                self.updateWidgetTransform(conf: conf, nodePair: nodePair, imageAnchor: imageAnchor)
            }
        } else if let objectAnchor = anchor as? ARObjectAnchor {
            printDebug("New ARObjectAnchor: \(objectAnchor.description)")
        }
    }

    func renderer(_: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor {
            imageAnchor.updatePlaneNode(on: node, scale: imageAnchor.estimatedScaleFactor)

            guard let conf = visContext.visConfiguration?.findImageConfiguration(anchor: imageAnchor) else {
                fatalErrorDebug("Cannot find corresponding image configuration for anchor: \(imageAnchor)")
                return
            }

            guard let nodePair = visContext.nodePair(url: conf.imageURL) else {
                fatalErrorDebug("Cannot find node pair for anchor: \(imageAnchor)")
                return
            }

            DispatchQueue.main.async {
                if self.trackingSwitch.isOn {
                    self.updateWidgetTransform(conf: conf, nodePair: nodePair, imageAnchor: imageAnchor)
                }
            }
        } else if let objectAnchor = anchor as? ARObjectAnchor {
            printDebug("New ARObjectAnchor: \(objectAnchor.description)")
        }
    }

    func renderer(_: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor {
            printDebug(level: .warning, "New ARImageAnchor Removed: \(imageAnchor.referenceImage.name ?? "No name provided.")")
            imageAnchor.removePlaneNode(on: node)

            guard let conf = visContext.visConfiguration?.findImageConfiguration(anchor: imageAnchor) else {
                fatalErrorDebug("Cannot find corresponding image configuration for anchor: \(imageAnchor)")
                return
            }

            guard let nodePair = visContext.nodePair(url: conf.imageURL) else {
                fatalErrorDebug("Cannot find node pair for anchor: \(imageAnchor)")
                return
            }

            nodePair._node.removeFromParentNode()
            nodePair.node.removeFromParentNode()
            visContext.set(nodePair: nil, for: conf.imageURL)
        } else if let objectAnchor = anchor as? ARObjectAnchor {
            printDebug("New ARObjectAnchor: \(objectAnchor.description)")
        }
    }
}

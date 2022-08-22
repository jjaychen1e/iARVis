//
//  ARKitViewController+ARSessionDelegate.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/7/28.
//

import ARKit
import UIKit

// MARK: - ARSessionDelegate

extension ARKitViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        for imageTrackingConfig in visContext.visConfiguration?.imageTrackingConfigurations ?? [] {
            for relationship in imageTrackingConfig.relationships {
                guard let nodePair = visContext.nodePairs(url: imageTrackingConfig.imageURL)?[relationship] else {
                    return
                }

                for (key, config) in relationship.widgetConfiguration.additionalWidgetConfiguration {
                    if nodePair.node.additionalWidgetNodes[key] == nil {
                        // Add new additional widget!
                        DispatchQueue.main.async {
                            let node = SCNWidgetNode(widgetConfiguration: config.widgetConfiguration)
                            node.geometry = {
                                let plane = SCNPlane()
                                plane.width = 0.4
                                plane.height = 0.4
                                return plane
                            }()
                            let widgetViewController = WidgetExampleViewController(node: node)
                            nodePair.node.additionalWidgetNodes[key] = node
                            nodePair.node.additionalWidgetNodes[key]?.widgetViewController = widgetViewController

                            let material: SCNMaterial = {
                                let material = SCNMaterial()
                                material.diffuse.contents = widgetViewController.view
                                return material
                            }()
                            node.geometry?.materials = [material]
                            nodePair.node.addChildNode(node)

                            let anchor: WidgetAnchorPoint = {
                                if config.widgetConfiguration.relativeAnchorPoint == .auto {
                                    let usedAnchorPoints = relationship.widgetConfiguration.additionalWidgetConfiguration.map { $0.1.widgetConfiguration.relativeAnchorPoint }
                                    return WidgetAnchorPoint.allCases.first(where: { !usedAnchorPoints.contains($0) }) ?? .top
                                } else {
                                    return config.widgetConfiguration.relativeAnchorPoint
                                }
                            }()

                            guard let originalNodePlane = nodePair.node.geometry as? SCNPlane,
                                  let newNodePlane = nodePair.node.geometry as? SCNPlane else {
                                fatalErrorDebug()
                                return
                            }

                            var oPlaneRealSize: CGSize = {
                                if let oWidgetConfig = nodePair.node.widgetConfiguration {
                                    let oWidgetSize = oWidgetConfig.size
                                    let oPlaneSize = originalNodePlane.size
                                    let oSquareSize = max(oWidgetSize.width, oWidgetSize.height)
                                    return CGSize(width: oPlaneSize.width * oWidgetSize.width / oSquareSize, height: oPlaneSize.height * oWidgetSize.height / oSquareSize)
                                }
                                return .zero
                            }()

                            var nPlaneRealSize: CGSize = {
                                let nWidgetConfig = config.widgetConfiguration
                                let nWidgetSize = nWidgetConfig.size
                                let nPlaneSize = newNodePlane.size
                                let nSquareSize = max(nWidgetSize.width, nWidgetSize.height)
                                return CGSize(width: nPlaneSize.width * nWidgetSize.width / nSquareSize, height: nPlaneSize.height * nWidgetSize.height / nSquareSize)
                            }()

                            var xOffset: CGFloat
                            var yOffset: CGFloat
                            switch anchor {
                            case .bottom:
                                xOffset = 0
                                yOffset = -oPlaneRealSize.height / 2 - nPlaneRealSize.height / 2
                            case .center:
                                xOffset = 0
                                yOffset = 0
                            case .leading:
                                xOffset = -oPlaneRealSize.width / 2 - nPlaneRealSize.width / 2
                                yOffset = 0
                            case .top:
                                xOffset = 0
                                yOffset = oPlaneRealSize.height / 2 + nPlaneRealSize.height / 2
                            case .trailing:
                                xOffset = oPlaneRealSize.width / 2 + nPlaneRealSize.width / 2
                                yOffset = 0
                            case .auto:
                                xOffset = 0
                                yOffset = 0
                            }
                            node.position = config.widgetConfiguration.relativePosition +
                                config.widgetConfiguration.positionOffset +
                                SCNVector3(Float(xOffset), Float(yOffset), 0)
                        }
                    }
                }
            }
        }
    }

    func session(_: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }

        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion,
        ]

        // Use `flatMap(_:)` to remove optional error messages.
        let errorMessage = messages.compactMap { $0 }.joined(separator: "\n")

        DispatchQueue.main.async {
            self.displayErrorMessage(title: "The AR session failed.", message: errorMessage)
        }
    }

    // MARK: - Error handling

    func displayErrorMessage(title: String, message: String) {
        // Present an alert informing about the error that has occurred.
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.resetTracking()
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }
}

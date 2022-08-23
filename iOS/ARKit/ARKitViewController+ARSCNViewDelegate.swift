//
//  ARKitViewController+ARSCNViewDelegate.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/21.
//

import ARKit

// MARK: - ARSCNViewDelegate

extension ARKitViewController: ARSCNViewDelegate {
    func renderer(_: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor {
            printDebug("New ARImageAnchor(\(imageAnchor) Added: \(imageAnchor.referenceImage.name ?? "No name provided.")")

            guard let conf = visContext.visConfiguration?.findImageConfiguration(anchor: imageAnchor) else {
                fatalErrorDebug("Cannot find corresponding image configuration for anchor: \(imageAnchor)")
                return
            }

//            imageAnchor.addPlaneNode(on: node, color: UIColor.blue.withAlphaComponent(0.5))

            for relationship in conf.relationships {
                let widgetNode = SCNWidgetNode(widgetConfiguration: relationship.widgetConfiguration)
                let nodePair = VisualizationContext.NodePair(node: widgetNode)
                visContext.set(nodePair: nodePair, for: conf.imageURL, relationship: relationship)
                DispatchQueue.main.async {
                    nodePair.node.geometry = {
                        let plane = SCNPlane()
                        plane.width = 0.4
                        plane.height = 0.4
                        return plane
                    }()
                    let widgetViewController = WidgetInARViewController(node: widgetNode)
                    widgetViewController.node = widgetNode
                    nodePair.node.widgetViewController = widgetViewController

                    let material: SCNMaterial = {
                        let material = SCNMaterial()
                        material.diffuse.contents = widgetViewController.view
                        return material
                    }()
                    widgetNode.geometry?.materials = [material]

                    node.addChildNode(nodePair._node)
                    self.sceneView.scene.rootNode.addChildNode(widgetNode)

                    self.updateWidgetTransform(conf: conf, relationship: relationship, nodePair: nodePair, imageAnchor: imageAnchor)
                }
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

            guard let nodePairs = visContext.nodePairs(url: conf.imageURL) else {
                return
            }

            DispatchQueue.main.async {
                if self.trackingSwitch.isOn {
                    for (relationship, nodePair) in nodePairs {
                        self.updateWidgetTransform(conf: conf, relationship: relationship, nodePair: nodePair, imageAnchor: imageAnchor)
                    }
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

            guard let nodePairs = visContext.nodePairs(url: conf.imageURL) else {
                fatalErrorDebug("Cannot find node pair for anchor: \(imageAnchor)")
                return
            }
            for (_, nodePair) in nodePairs {
                nodePair._node.removeFromParentNode()
                nodePair.node.removeFromParentNode()
            }
            for relationship in conf.relationships {
                visContext.set(nodePair: nil, for: conf.imageURL, relationship: relationship)
            }
        } else if let objectAnchor = anchor as? ARObjectAnchor {
            printDebug("New ARObjectAnchor: \(objectAnchor.description)")
        }
    }
}

// MARK: - Widget position

extension ARKitViewController {
    private func updateWidgetTransform(conf: ImageTrackingConfiguration, relationship: WidgetImageRelationship, nodePair: VisualizationContext.NodePair, imageAnchor: ARImageAnchor) {
        guard let plane = nodePair.node.geometry as? SCNPlane else {
            fatalErrorDebug()
            return
        }

        let anchor: WidgetAnchorPoint = {
            if relationship.widgetConfiguration.relativeAnchorPoint == .auto {
                let usedAnchorPoints = conf.relationships.map { $0.widgetConfiguration.relativeAnchorPoint }
                return WidgetAnchorPoint.allCases.first(where: { !usedAnchorPoints.contains($0) }) ?? .top
            } else {
                return relationship.widgetConfiguration.relativeAnchorPoint
            }
        }()

        let targetImageSize = imageAnchor.referenceImage.physicalSize * imageAnchor.estimatedScaleFactor
        var xOffset: CGFloat
        var yOffset: CGFloat
        switch anchor {
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
        case .auto:
            xOffset = 0
            yOffset = 0
        }
        nodePair._node.position = relationship.widgetConfiguration.relativePosition + relationship.widgetConfiguration.positionOffset + SCNVector3(Float(xOffset), Float(yOffset), 0)
        nodePair._node.eulerAngles = SCNVector3(-CGFloat.pi / 2, 0, 0)
        nodePair.node.setWorldTransform(nodePair._node.worldTransform)
    }
}

//
//  ImageTrackingConfiguration.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/7/31.
//

import Foundation
import SceneKit

class ImageTrackingConfiguration {
    var imageURL: URL
    var relativeAnchorPoint: AnchorPoint
    var relativePosition: SCNVector3
    var positionOffset: SCNVector3 = .init(x: 0, y: 0, z: 0)

    init(imageURL: URL, relativeAnchorPoint: AnchorPoint, relativePosition: SCNVector3) {
        self.imageURL = imageURL
        self.relativeAnchorPoint = relativeAnchorPoint
        self.relativePosition = relativePosition
    }
}

extension ImageTrackingConfiguration {
    enum AnchorPoint {
        case center
        case leading
        case trailing
        case top
        case bottom
    }
}

extension ImageTrackingConfiguration {
    static let example1 = ImageTrackingExample.exampleConfiguration1
}

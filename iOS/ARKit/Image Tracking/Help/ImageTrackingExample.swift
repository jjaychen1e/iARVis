//
//  ImageTrackingExample.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/7/31.
//

import Foundation
import SceneKit

struct ImageTrackingExample {
    private static let exampleImageURL1: URL = .init(string: "https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2022/default/namecard.png")!
    private static let exampleImageURL2: URL = .init(string: "https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2022/default/jasper-gribble-TgQUt4fz9s8-unsplash.jpg")!

    static let exampleConfiguration1: ImageTrackingConfiguration = .init(imageURL: exampleImageURL1,
                                                                         relativeAnchorPoint: .trailing,
                                                                         relativePosition: SCNVector3(0.2, 0, 0))
    static let exampleConfiguration2: ImageTrackingConfiguration = .init(imageURL: exampleImageURL2,
                                                                         relativeAnchorPoint: .leading,
                                                                         relativePosition: SCNVector3(0.2, 0, 0))
}

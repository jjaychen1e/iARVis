//
//  ImageTrackingExample.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/7/31.
//

import Foundation
import SceneKit

struct ImageTrackingExample {
    private static let exampleImageURL1: URL = .init(string: "https://media.getty.edu/iiif/image/ce4d5a1f-ee25-44b3-afa2-d597d43056ff/full/1024,/0/default.jpg?download=ce4d5a1f-ee25-44b3-afa2-d597d43056ff_1024.jpg&size=small")!
    private static let exampleImageURL2: URL = .init(string: "https://www.data-to-viz.com/story/OneCatSevOrderedNum_files/figure-html/unnamed-chunk-3-1.png")!
//    private static let exampleImageURL2: URL = .init(string: "https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2022/default/jasper-gribble-TgQUt4fz9s8-unsplash.jpg")!

    static let exampleConfiguration1: ImageTrackingConfiguration = .init(
        imageURL: exampleImageURL1,
        relationships: [
            .init(widgetConfiguration: .init(component: .example1_ArtworkWidget,
                                             relativeAnchorPoint: .trailing,
                                             relativePosition: SCNVector3(0.2, 0, 0))),
        ]
    )
    static let exampleConfiguration2: ImageTrackingConfiguration = .init(
        imageURL: exampleImageURL2,
        relationships: [
            .init(widgetConfiguration: .init(component: .example2_AppleSilicon,
                                             relativeAnchorPoint: .trailing,
                                             relativePosition: SCNVector3(0.2, 0, 0),
                                             additionalWidgetConfiguration: [
                                                 ViewElementComponent.example2_AppleSilicon.prettyJSON: AdditionalWidgetConfiguration(
                                                     key: ViewElementComponent.example2_AppleSilicon.prettyJSON,
                                                     widgetConfiguration: WidgetConfiguration(
                                                         component: .example2_AppleSilicon,
                                                         relativeAnchorPoint: .leading,
                                                         relativePosition: .init(-0.005, 0, 0)
                                                     )
                                                 ),
                                             ])),
        ]
    )
}

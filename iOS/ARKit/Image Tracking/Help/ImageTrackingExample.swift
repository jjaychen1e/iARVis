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
    private static let exampleImageURL2: URL = .init(string: "https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2022/default/Ashley5.jpg")!
//    private static let exampleImageURL2: URL = .init(string: "https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2022/default/jasper-gribble-TgQUt4fz9s8-unsplash.jpg")!
    
    private static let exampleImageURL3: URL = .init(string: "https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2022/default/Ridgeline%20Chart.jpg")!

    static let exampleConfiguration1: ImageTrackingConfiguration = .init(
        imageURL: exampleImageURL1,
        relationships: [
            .init(widgetConfiguration: .init(component: .example1_ArtworkWidget,
                                             relativeAnchorPoint: .trailing,
                                             relativePosition: SCNVector3(0.005, 0, 0))),
        ]
    )

    static let exampleConfiguration2: ImageTrackingConfiguration = .init(
        imageURL: exampleImageURL2,
        relationships: [
            .init(widgetConfiguration: .init(component: .example3BabyNamesAreaChartAshleyViewElementComponent,
                                             relativeAnchorPoint: .center,
                                             relativePosition: SCNVector3(0, 0, 0),
                                             scale: ScaleDefaultValueProvider.level_1,
                                             additionalWidgetConfiguration: [
                                                 ViewElementComponent.example3BabyNamesAreaChartDorothyViewElementComponent.prettyJSON: AdditionalWidgetConfiguration(
                                                     key: ViewElementComponent.example3BabyNamesAreaChartDorothyViewElementComponent.prettyJSON,
                                                     widgetConfiguration: WidgetConfiguration(
                                                         component: .example3BabyNamesAreaChartDorothyViewElementComponent,
                                                         relativeAnchorPoint: .leading,
                                                         relativePosition: .init(-0.02, 0, 0),
                                                         scale: ScaleDefaultValueProvider.level_1
                                                     )
                                                 ),
                                                 ViewElementComponent.example3BabyNamesAreaChartHelenViewElementComponent.prettyJSON: AdditionalWidgetConfiguration(
                                                     key: ViewElementComponent.example3BabyNamesAreaChartHelenViewElementComponent.prettyJSON,
                                                     widgetConfiguration: WidgetConfiguration(
                                                         component: .example3BabyNamesAreaChartHelenViewElementComponent,
                                                         relativeAnchorPoint: .trailing,
                                                         relativePosition: .init(0.02, 0, 0),
                                                         scale: ScaleDefaultValueProvider.level_1
                                                     )
                                                 ),
                                                 ViewElementComponent.example3BabyNamesAreaChartAmandaViewElementComponent.prettyJSON: AdditionalWidgetConfiguration(
                                                     key: ViewElementComponent.example3BabyNamesAreaChartAmandaViewElementComponent.prettyJSON,
                                                     widgetConfiguration: WidgetConfiguration(
                                                         component: .example3BabyNamesAreaChartAmandaViewElementComponent,
                                                         relativeAnchorPoint: .top,
                                                         relativePosition: .init(0, 0.02, 0),
                                                         scale: ScaleDefaultValueProvider.level_1,
                                                         additionalWidgetConfiguration: [
                                                             ViewElementComponent.example3BabyNamesAreaChartBettyViewElementComponent.prettyJSON: AdditionalWidgetConfiguration(
                                                                 key: ViewElementComponent.example3BabyNamesAreaChartBettyViewElementComponent.prettyJSON,
                                                                 widgetConfiguration: WidgetConfiguration(
                                                                     component: .example3BabyNamesAreaChartBettyViewElementComponent,
                                                                     relativeAnchorPoint: .leading,
                                                                     relativePosition: .init(-0.02, 0, 0),
                                                                     scale: ScaleDefaultValueProvider.level_1
                                                                 )
                                                             ),
                                                             ViewElementComponent.example3BabyNamesAreaChartDeborahViewElementComponent.prettyJSON: AdditionalWidgetConfiguration(
                                                                 key: ViewElementComponent.example3BabyNamesAreaChartDeborahViewElementComponent.prettyJSON,
                                                                 widgetConfiguration: WidgetConfiguration(
                                                                     component: .example3BabyNamesAreaChartDeborahViewElementComponent,
                                                                     relativeAnchorPoint: .trailing,
                                                                     relativePosition: .init(0.02, 0, 0),
                                                                     scale: ScaleDefaultValueProvider.level_1
                                                                 )
                                                             ),
                                                         ]
                                                     )
                                                 ),
                                                 ViewElementComponent.example3BabyNamesAreaChartJessicaViewElementComponent.prettyJSON: AdditionalWidgetConfiguration(
                                                     key: ViewElementComponent.example3BabyNamesAreaChartJessicaViewElementComponent.prettyJSON,
                                                     widgetConfiguration: WidgetConfiguration(
                                                         component: .example3BabyNamesAreaChartJessicaViewElementComponent,
                                                         relativeAnchorPoint: .bottom,
                                                         relativePosition: .init(0, -0.02, 0),
                                                         scale: ScaleDefaultValueProvider.level_1,
                                                         additionalWidgetConfiguration: [
                                                             ViewElementComponent.example3BabyNamesAreaChartLindaViewElementComponent.prettyJSON: AdditionalWidgetConfiguration(
                                                                 key: ViewElementComponent.example3BabyNamesAreaChartLindaViewElementComponent.prettyJSON,
                                                                 widgetConfiguration: WidgetConfiguration(
                                                                     component: .example3BabyNamesAreaChartLindaViewElementComponent,
                                                                     relativeAnchorPoint: .leading,
                                                                     relativePosition: .init(-0.02, 0, 0),
                                                                     scale: ScaleDefaultValueProvider.level_1
                                                                 )
                                                             ),
                                                             ViewElementComponent.example3BabyNamesAreaChartPatriciaViewElementComponent.prettyJSON: AdditionalWidgetConfiguration(
                                                                 key: ViewElementComponent.example3BabyNamesAreaChartPatriciaViewElementComponent.prettyJSON,
                                                                 widgetConfiguration: WidgetConfiguration(
                                                                     component: .example3BabyNamesAreaChartPatriciaViewElementComponent,
                                                                     relativeAnchorPoint: .trailing,
                                                                     relativePosition: .init(0.02, 0, 0),
                                                                     scale: ScaleDefaultValueProvider.level_1
                                                                 )
                                                             ),
                                                         ]
                                                     )
                                                 ),
                                             ])),
        ]
    )

    static let exampleConfiguration3: ImageTrackingConfiguration = .init(
        imageURL: exampleImageURL3,
        relationships: [
            .init(widgetConfiguration: .init(component: .example3_AreaChartMatrix,
                                             relativeAnchorPoint: .trailing,
                                             relativePosition: SCNVector3(0, 0, 0),
                                             isScrollEnabled: false,
                                             scale: ScaleDefaultValueProvider.level_3,
                                             size: CGSize(width: 2048, height: 1680))),
        ]
    )
}

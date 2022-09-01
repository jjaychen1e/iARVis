//
//  ViewElementComponent+Example2+MacBookPro.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/8/29.
//

import Foundation

extension ViewElementComponent {
    static let example2_MacBookPro: ViewElementComponent = .vStack(elements: [
        .hStack(elements: [
            .vStack(elements: [
                .text(content: "MacBook Pro (16-inch, 2021)", fontStyle: ARVisFontStyle(size: 40, weight: .bold)),
                .text(content: """
                The **MacBook Pro (16-inch, 2021)** was introduced at Apple's **'Unleashed'** event on 18 October 2021, and is the first MacBook Pro (16-inch) to feature [Apple Silicon](https://en.wikipedia.org/wiki/Apple_silicon#M_series) as part of the transition from x86_64-based Intel processors.
                It was made available for preorder on 18 October 2021, and for purchase on 26 October 2021.
                The firmware identifiers are [MacBookPro18,1](https://www.theiphonewiki.com/wiki/J316sAP) ([M1 Pro](https://www.theiphonewiki.com/wiki/T6000)) and [MacBookPro18,2](https://www.theiphonewiki.com/wiki/J316cAP) ([M1 Max](https://www.theiphonewiki.com/wiki/T6001)).
                """, fontStyle: ARVisFontStyle(size: 22)),
            ], alignment: .leading),
            .spacer,
            .image(url: "https://cdn.jsdelivr.net/gh/JJAYCHEN1e/Image@2022/default/large_0074.jpg", width: 500),
        ], alignment: .top),
        .divider(),
        .segmentedControl(items: [
            ARVisSegmentedControlItem(title: "Specifications", component: .spacer),
            ARVisSegmentedControlItem(title: "Family History", component: example2_MacBookProFamilyChartViewElementComponent),
            ARVisSegmentedControlItem(title: "Performance", component: .spacer),
            ARVisSegmentedControlItem(title: "Technical Reviews", component: .spacer),
        ]),
    ])

    static let example2_MacBookProFamilyChartViewElementComponentJSONStr = """
    {
        "vStack": {
            "elements": [
                {
                    "chart": \(ChartConfigurationExample.chartConfigurationExample2_MacBookProFamilyChart)
                },
            ]
        }
    }
    """

    static let example2_MacBookProFamilyChartViewElementComponent: ViewElementComponent = try! JSONDecoder().decode(ViewElementComponent.self, from: example2_MacBookProFamilyChartViewElementComponentJSONStr.data(using: .utf8)!)
}

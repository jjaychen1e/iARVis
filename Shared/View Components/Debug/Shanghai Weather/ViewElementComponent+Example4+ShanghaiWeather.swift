//
//  ViewElementComponent+Example4+ShanghaiWeather.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/9/5.
//

import Foundation
extension ViewElementComponent {
    static let example4_ShanghaiWeatherPointChartJSONStrJSONStr = """
    {
        "vStack": {
            "elements": [
                {
                    "chart": \(ChartConfigurationExample.chartConfigurationExample4_ShanghaiWeatherPointChart)
                },
            ]
        }
    }
    """

    static let example4_ShanghaiWeatherPointChartJSONStrViewElementComponent: ViewElementComponent = try! JSONDecoder().decode(ViewElementComponent.self, from: example4_ShanghaiWeatherPointChartJSONStrJSONStr.data(using: .utf8)!)
}

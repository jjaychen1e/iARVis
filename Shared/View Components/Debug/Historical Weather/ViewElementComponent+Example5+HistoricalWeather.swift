//
//  ViewElementComponent+Example5+HistoricalWeather.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/9/6.
//

import Foundation
import Foundation
extension ViewElementComponent {
    static let example4_HistoricalWeatherPointChartJSONStr = """
    {
        "vStack": {
            "elements": [
                {
                    "chart": \(ChartConfigurationExample.chartConfigurationExample5_WeatherHistoryChart)
                },
            ]
        }
    }
    """

    static let example5_HistoricalWeatherPointChartViewElementComponent: ViewElementComponent = try! JSONDecoder().decode(ViewElementComponent.self, from: example4_HistoricalWeatherPointChartJSONStr.data(using: .utf8)!)
}

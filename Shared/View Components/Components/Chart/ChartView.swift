//
//  ChartView.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/14.
//

import Charts
import SwiftUI
import SwiftyJSON

struct ChartView: View {
    @State var chartConfiguration: ChartConfiguration

    var body: some View {
        Chart {
            ForEach(0 ..< chartConfiguration.components.count, id: \.self) { index in
                let component = chartConfiguration.components[index]
                component.toChartContent(configuration: chartConfiguration)
            }
        }
        .if(chartConfiguration.chartXScale.includingZero != nil) { view in
            view.chartXScale(domain: .automatic(includesZero: chartConfiguration.chartXScale.includingZero!))
        }
        .if(chartConfiguration.chartXScale.domain != nil) { view in
            if let domain = chartConfiguration.chartXScale.domain, domain.count >= 2 {
                if let xStart = domain[0].int, let xEnd = domain[1].int {
                    view.chartXScale(domain: min(xStart, xEnd) ... max(xStart, xEnd))
                } else if let xStart = domain[0].double, let xEnd = domain[1].double {
                    view.chartXScale(domain: min(xStart, xEnd) ... max(xStart, xEnd))
                } else if let xStart = domain[0].date, let xEnd = domain[1].date {
                    view.chartXScale(domain: min(xStart, xEnd) ... max(xStart, xEnd))
                }
            }
        }
        .chartOverlay { proxy in
            chartInteractionHandler(proxy: proxy)
        }
        .chartOverlay { proxy in
            chartOverlayHandler(proxy: proxy)
        }
//        .chartOverlay { _ in
//            #if DEBUG
//                GeometryReader { _ in
//                    ForEach(0 ..< chartConfiguration.components.count, id: \.self) { index in
//                        let component = chartConfiguration.components[index]
//                        if let selectedElement = chartConfiguration.interactionData.componentSelectedElementInRangeX[component] {
//                            Text(selectedElement.description)
//                        }
//                    }
//                }
//            #endif
//        }
        .frame(width: chartConfiguration.styleConfiguration.maxWidth, height: chartConfiguration.styleConfiguration.maxHeight ?? 200)
        .padding(.vertical)
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        let chartConfiguration = ChartConfigurationJSONParser.default.parse(JSON(ChartConfigurationJSONParser.exampleJSONString1.data(using: .utf8)!))
        ChartView(chartConfiguration: chartConfiguration)
            .previewLayout(.fixed(width: 720, height: 540))
    }
}

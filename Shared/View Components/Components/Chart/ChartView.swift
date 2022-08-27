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
            ForEach(0 ..< chartConfiguration.componentConfigs.count, id: \.self) { index in
                let componentConfig = chartConfiguration.componentConfigs[index]
                componentConfig.toChartContent(configuration: chartConfiguration)
            }
        }
        .if(chartConfiguration.chartXAxis != nil) { view in
            if let chartXAxis = chartConfiguration.chartXAxis {
                if chartXAxis.hidden == true {
                    view.chartXAxis(.hidden)
                } else {
                    if let axisMarks = chartXAxis.axisMarks {
                        let values: AxisMarkValues = {
                            switch axisMarks.axisMarksValues {
                            case let .strideByDateComponent(component, count):
                                return AxisMarkValues.stride(by: .init(component), count: count)
                            }
                        }()
                        view
                            .chartXAxis {
                                AxisMarks(values: values) { _ in
                                    AxisGridLine()
                                    AxisTick()
                                    switch axisMarks.axisValueLabel.format {
                                    case let .year(format):
                                        switch format {
                                        case .defaultDigits:
                                            AxisValueLabel(format: .dateTime.year(.defaultDigits))
                                        }
                                    }
                                }
                            }
                    }
                }
            }
        }
        .if(chartConfiguration.chartYAxis != nil) { view in
            if let chartYAxis = chartConfiguration.chartYAxis {
                if chartYAxis.hidden == true {
                    view.chartYAxis(.hidden)
                } else {
                    if let axisMarks = chartYAxis.axisMarks {
                        let values: AxisMarkValues = {
                            switch axisMarks.axisMarksValues {
                            case let .strideByDateComponent(component, count):
                                return AxisMarkValues.stride(by: .init(component), count: count)
                            }
                        }()
                        view
                            .chartYAxis {
                                AxisMarks(values: values) { _ in
                                    AxisGridLine()
                                    AxisTick()
                                    switch axisMarks.axisValueLabel.format {
                                    case let .year(format):
                                        switch format {
                                        case .defaultDigits:
                                            AxisValueLabel(format: .dateTime.year(.defaultDigits))
                                        }
                                    }
                                }
                            }
                    }
                }
            }
        }
        .if(chartConfiguration.chartXScale?.includingZero != nil) { view in
            if let includingZero = chartConfiguration.chartXScale?.includingZero {
                view.chartXScale(domain: .automatic(includesZero: includingZero))
            }
        }
        .if(chartConfiguration.chartXScale?.domain != nil) { view in
            if let domain = chartConfiguration.chartXScale?.domain, domain.count >= 2 {
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
        .frame(width: chartConfiguration.styleConfiguration?.maxWidth, height: chartConfiguration.styleConfiguration?.maxHeight ?? nil)
        .frame(maxHeight: chartConfiguration.styleConfiguration?.maxHeight == nil ? 200 : nil)
        .if(true) { view in
            if let padding = chartConfiguration.styleConfiguration?.padding {
                view
                    .padding(.leading, padding[safe: 0])
                    .padding(.top, padding[safe: 1])
                    .padding(.trailing, padding[safe: 2])
                    .padding(.bottom, padding[safe: 3])
            } else {
                view.padding(.vertical)
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        let chartConfiguration = ChartConfigurationJSONParser.default.parse(JSON(ChartConfigurationJSONParser.exampleJSONString1.data(using: .utf8)!))
        ChartView(chartConfiguration: chartConfiguration)
            .previewLayout(.fixed(width: 720, height: 540))
    }
}

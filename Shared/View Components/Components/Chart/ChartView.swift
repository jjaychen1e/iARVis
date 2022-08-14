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
            GeometryReader { geo in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { value in
                                let location = value.location
                                for component in chartConfiguration.components {
                                    switch component {
                                    case let .barMarkRepeat1(xStart, xEnd, _, _):
                                        if let dataItem = getElementInRangeX(proxy: proxy,
                                                                             location: location,
                                                                             geo: geo,
                                                                             chartData: chartConfiguration.chartData,
                                                                             xStartField: xStart.field,
                                                                             xEndField: xEnd.field)
                                        {
                                            // TODO: 这部分逻辑在拥有第二种 component 之后抽离出去，把 switch 部分放在一个函数中，返回找到的 dataItem
                                            if chartConfiguration.interactionData.componentSelectedElement[component] == dataItem {
                                                chartConfiguration.interactionData.componentSelectedElement[component] = nil
                                            } else {
                                                chartConfiguration.interactionData.componentSelectedElement[component] = dataItem
                                            }
                                        }
                                    }
                                }
                            }
                            .exclusively(
                                before: DragGesture()
                                    .onChanged { value in
                                        let location = value.location
                                        for component in chartConfiguration.components {
                                            switch component {
                                            case let .barMarkRepeat1(xStart, xEnd, _, _):
                                                if let dataItem = getElementInRangeX(proxy: proxy,
                                                                                     location: location,
                                                                                     geo: geo,
                                                                                     chartData: chartConfiguration.chartData,
                                                                                     xStartField: xStart.field,
                                                                                     xEndField: xEnd.field)
                                                {
                                                    chartConfiguration.interactionData.componentSelectedElement[component] = dataItem
                                                }
                                            }
                                        }
                                    }
                            )
                    )
            }
        }
        .chartOverlay { _ in
            ForEach(0 ..< chartConfiguration.components.count, id: \.self) { index in
                let component = chartConfiguration.components[index]
                if let selectedElement = chartConfiguration.interactionData.componentSelectedElement[component] {
                    Text(selectedElement.description)
                }
            }
        }
        .frame(maxWidth: chartConfiguration.styleConfiguration.maxWidth, maxHeight: chartConfiguration.styleConfiguration.maxHeight)
        .padding()
    }
}

private func getElementInRangeX(proxy: ChartProxy, location: CGPoint, geo: GeometryProxy, chartData: ChartData, xStartField: String, xEndField: String) -> JSON? {
    let relativeX = location.x - geo[proxy.plotAreaFrame].origin.x
    // Int, Double, Date
    if chartData.data[xStartField].array?[safe: 0]?.int != nil {
        if let dateValue: Int = proxy.value(atX: relativeX) {
            for i in 0 ..< chartData.length {
                if let xStartInt = chartData.data[xStartField].array?[safe: i]?.int,
                   let xEndInt = chartData.data[xEndField].array?[safe: i]?.int,
                   dateValue >= xStartInt, dateValue <= xEndInt {
                    var dict: [String: JSON] = [:]
                    for title in chartData.titles {
                        dict[title] = chartData.data[title].array?[safe: i]
                    }
                    return JSON(dict)
                }
            }
        }
    } else if chartData.data[xStartField].array?[safe: 0]?.double != nil {
        if let dateValue: Double = proxy.value(atX: relativeX) {
            for i in 0 ..< chartData.length {
                if let xStartDouble = chartData.data[xStartField].array?[safe: i]?.double,
                   let xEndDouble = chartData.data[xEndField].array?[safe: i]?.double,
                   dateValue >= xStartDouble, dateValue <= xEndDouble {
                    var dict: [String: JSON] = [:]
                    for title in chartData.titles {
                        dict[title] = chartData.data[title].array?[safe: i]
                    }
                    return JSON(dict)
                }
            }
        }
    } else if chartData.data[xStartField].array?[safe: 0]?.date != nil {
        if let dateValue: Date = proxy.value(atX: relativeX) {
            for i in 0 ..< chartData.length {
                if let xStartDate = chartData.data[xStartField].array?[safe: i]?.date,
                   let xEndDate = chartData.data[xEndField].array?[safe: i]?.date,
                   dateValue >= xStartDate, dateValue <= xEndDate {
                    var dict: [String: JSON] = [:]
                    for title in chartData.titles {
                        dict[title] = chartData.data[title].array?[safe: i]
                    }
                    return JSON(dict)
                }
            }
        }
    }
    return nil
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(chartConfiguration: .example1)
            .previewLayout(.fixed(width: 720, height: 540))
    }
}

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
                                    case let .barMarkRepeat1(xStart, xEnd, y, _):
                                        if let dataItemRangeX = getElementInRangeX(proxy: proxy,
                                                                                   location: location,
                                                                                   geo: geo,
                                                                                   chartData: chartConfiguration.chartData,
                                                                                   xStartField: xStart.field,
                                                                                   xEndField: xEnd.field)
                                        {
                                            // TODO: 这部分逻辑在拥有第二种 component 之后抽离出去
                                            if chartConfiguration.interactionData.componentSelectedElementInRangeX[component] == dataItemRangeX {
                                                chartConfiguration.interactionData.componentSelectedElementInRangeX[component] = nil
                                            } else {
                                                chartConfiguration.interactionData.componentSelectedElementInRangeX[component] = dataItemRangeX
                                            }
                                        } else {
                                            chartConfiguration.interactionData.componentSelectedElementInRangeX[component] = nil
                                        }

                                        if let dataItemRangeY = getElementInRangeY(proxy: proxy,
                                                                                   location: location,
                                                                                   geo: geo,
                                                                                   chartData: chartConfiguration.chartData,
                                                                                   yStartField: y.field,
                                                                                   yEndField: y.field) {
                                            // Click on the bar!
                                            if chartConfiguration.interactionData.componentSelectedElementInRangeY[component] == dataItemRangeY {
                                                chartConfiguration.interactionData.componentSelectedElementInRangeY[component] = nil
                                            } else {
                                                chartConfiguration.interactionData.componentSelectedElementInRangeY[component] = dataItemRangeY
                                            }

                                            if chartConfiguration.interactionData.componentSelectedElementInRangeX[component] == dataItemRangeY {
                                                if chartConfiguration.interactionData.componentSelectedElementInXY[component] == dataItemRangeY {
                                                    chartConfiguration.interactionData.componentSelectedElementInXY[component] = nil
                                                } else {
                                                    chartConfiguration.interactionData.componentSelectedElementInXY[component] = dataItemRangeY
                                                }
                                            } else {
                                                chartConfiguration.interactionData.componentSelectedElementInXY[component] = nil
                                            }
                                        } else {
                                            chartConfiguration.interactionData.componentSelectedElementInRangeY[component] = nil
                                        }
                                    }

                                    // Tap gesture can trigger click and hover!
                                    if let interactions = chartConfiguration.interactionData.componentInteraction[component] {
                                        for interaction in interactions {
                                            switch interaction {
                                            case let .click(action):
                                                switch action {
                                                case let .openURL(url):
                                                    if let _ = chartConfiguration.interactionData.componentSelectedElementInXY[component] {
//                                                        UIApplication.shared.open(url)
                                                    }
                                                }
                                            case let .hover(tooltip):
                                                switch tooltip {
                                                case .auto:
                                                    fatalErrorDebug("Not implemented yet.")
                                                case let .manual(contents):
                                                    switch component.hoverType {
                                                    case .rangeX:
                                                        if let dataItem = chartConfiguration.interactionData.componentSelectedElementInRangeX[component] {
                                                            var found = false
                                                            for content in contents {
                                                                if dataItem[content.field] == content.value {
                                                                    chartConfiguration.interactionData.componentSelectedElementView[component] = content.content
                                                                    found = true
                                                                    break
                                                                }
                                                            }
                                                            if !found {
                                                                chartConfiguration.interactionData.componentSelectedElementView[component] = nil
                                                            }
                                                        }
                                                    case .rangeY:
                                                        if let dataItem = chartConfiguration.interactionData.componentSelectedElementInRangeY[component] {
                                                            var found = false
                                                            for content in contents {
                                                                if dataItem[content.field] == content.value {
                                                                    chartConfiguration.interactionData.componentSelectedElementView[component] = content.content
                                                                    found = true
                                                                    break
                                                                }
                                                            }
                                                            if !found {
                                                                chartConfiguration.interactionData.componentSelectedElementView[component] = nil
                                                            }
                                                        }
                                                    case .xy:
                                                        if let dataItem = chartConfiguration.interactionData.componentSelectedElementInXY[component] {
                                                            var found = false
                                                            for content in contents {
                                                                if dataItem[content.field] == content.value {
                                                                    chartConfiguration.interactionData.componentSelectedElementView[component] = content.content
                                                                    found = true
                                                                    break
                                                                }
                                                            }
                                                            if !found {
                                                                chartConfiguration.interactionData.componentSelectedElementView[component] = nil
                                                            }
                                                        }
                                                    }
                                                }
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
                                            case let .barMarkRepeat1(xStart, xEnd, y, _):
                                                if let dataItemRangeX = getElementInRangeX(proxy: proxy,
                                                                                           location: location,
                                                                                           geo: geo,
                                                                                           chartData: chartConfiguration.chartData,
                                                                                           xStartField: xStart.field,
                                                                                           xEndField: xEnd.field)
                                                {
                                                    chartConfiguration.interactionData.componentSelectedElementInRangeX[component] = dataItemRangeX
                                                } else {
                                                    chartConfiguration.interactionData.componentSelectedElementInRangeX[component] = nil
                                                }

                                                if let dataItemRangeY = getElementInRangeY(proxy: proxy,
                                                                                           location: location,
                                                                                           geo: geo,
                                                                                           chartData: chartConfiguration.chartData,
                                                                                           yStartField: y.field,
                                                                                           yEndField: y.field) {
                                                    // Click on the bar!
                                                    chartConfiguration.interactionData.componentSelectedElementInRangeY[component] = dataItemRangeY

                                                    if chartConfiguration.interactionData.componentSelectedElementInRangeX[component] == dataItemRangeY {
                                                        chartConfiguration.interactionData.componentSelectedElementInXY[component] = dataItemRangeY
                                                    } else {
                                                        chartConfiguration.interactionData.componentSelectedElementInXY[component] = nil
                                                    }
                                                } else {
                                                    chartConfiguration.interactionData.componentSelectedElementInRangeY[component] = nil
                                                }
                                            }

                                            // Drag gesture can only trigger hover!
                                            if let interactions = chartConfiguration.interactionData.componentInteraction[component] {
                                                for interaction in interactions {
                                                    switch interaction {
                                                    case let .hover(tooltip):
                                                        switch tooltip {
                                                        case .auto:
                                                            fatalErrorDebug("Not implemented yet.")
                                                        case let .manual(contents):
                                                            switch component.hoverType {
                                                            case .rangeX:
                                                                if let dataItem = chartConfiguration.interactionData.componentSelectedElementInRangeX[component] {
                                                                    var found = false
                                                                    for content in contents {
                                                                        if dataItem[content.field] == content.value {
                                                                            chartConfiguration.interactionData.componentSelectedElementView[component] = content.content
                                                                            found = true
                                                                            break
                                                                        }
                                                                    }
                                                                    if !found {
                                                                        chartConfiguration.interactionData.componentSelectedElementView[component] = nil
                                                                    }
                                                                }
                                                            case .rangeY:
                                                                if let dataItem = chartConfiguration.interactionData.componentSelectedElementInRangeY[component] {
                                                                    var found = false
                                                                    for content in contents {
                                                                        if dataItem[content.field] == content.value {
                                                                            chartConfiguration.interactionData.componentSelectedElementView[component] = content.content
                                                                            found = true
                                                                            break
                                                                        }
                                                                    }
                                                                    if !found {
                                                                        chartConfiguration.interactionData.componentSelectedElementView[component] = nil
                                                                    }
                                                                }
                                                            case .xy:
                                                                if let dataItem = chartConfiguration.interactionData.componentSelectedElementInXY[component] {
                                                                    var found = false
                                                                    for content in contents {
                                                                        if dataItem[content.field] == content.value {
                                                                            chartConfiguration.interactionData.componentSelectedElementView[component] = content.content
                                                                            found = true
                                                                            break
                                                                        }
                                                                    }
                                                                    if !found {
                                                                        chartConfiguration.interactionData.componentSelectedElementView[component] = nil
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    default:
                                                        break
                                                    }
                                                }
                                            }
                                        }
                                    }
                            )
                    )
            }
        }
        .chartOverlay { _ in
            #if DEBUG
                GeometryReader { _ in
                    ForEach(0 ..< chartConfiguration.components.count, id: \.self) { index in
                        let component = chartConfiguration.components[index]
                        if let selectedElement = chartConfiguration.interactionData.componentSelectedElementInRangeX[component] {
//                            Text(selectedElement.description)
                        }
                    }
                }
            #endif
        }
        .chartOverlay { proxy in
            GeometryReader { geoProxy in
                let topOffset = -geoProxy.frame(in: .global).origin.y
                ForEach(0 ..< chartConfiguration.components.count, id: \.self) { index in
                    let component = chartConfiguration.components[index]
                    if let viewComponent = chartConfiguration.interactionData.componentSelectedElementView[component] {
                        switch component {
                        case let .barMarkRepeat1(xStart, xEnd, y, _):
                            if let selectedElement = chartConfiguration.interactionData.componentSelectedElementInRangeX[component] {
                                if let leftPoint = proxy.position(at: (selectedElement[xStart.field], selectedElement[y.field])),
                                   let rightPoint = proxy.position(at: (selectedElement[xEnd.field], selectedElement[y.field])) {
                                    let centerPoint = (leftPoint + rightPoint) / 2
                                    let targetSize = ChartTooltipView(viewComponent).adaptiveSizeThatFits(in: .init(width: 300, height: 250), for: .regular)
                                    ChartTooltipView(viewComponent)
                                        .frame(width: targetSize.width, height: targetSize.height)
                                        .offset(x: max(0, centerPoint.x - targetSize.width / 2), y: max(topOffset + 8, centerPoint.y - targetSize.height))
                                        .id(selectedElement.rawString(options: []))
                                }
                            }
                        }
                    }
                }
            }
            .animation(.default, value: chartConfiguration.interactionData.componentSelectedElementView)
            .transition(.opacity)
        }
        .frame(maxWidth: chartConfiguration.styleConfiguration.maxWidth, maxHeight: chartConfiguration.styleConfiguration.maxHeight)
        .padding()
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        let chartConfiguration = ChartConfigurationJSONParser.default.parse(JSON(ChartConfigurationJSONParser.exampleJSONString1.data(using: .utf8)!)["chartConfig"])
        ChartView(chartConfiguration: chartConfiguration)
            .previewLayout(.fixed(width: 720, height: 540))
    }
}

//
//  ChartView+Interaction.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/23.
//

import Charts
import Foundation
import SwiftUI

extension ChartView {
    private func updateInteractionData(component: ChartComponent,
                                       location: CGPoint,
                                       proxy: ChartProxy,
                                       geo: GeometryProxy,
                                       xStartField: String,
                                       xEndField: String,
                                       yStartField: String,
                                       yEndField: String,
                                       isClick: Bool,
                                       modeX: GetElementMode = .accurate,
                                       modeY: GetElementMode = .accurate) {
        if let dataItemRangeX = getElementInRangeX(proxy: proxy,
                                                   location: location,
                                                   geo: geo,
                                                   chartData: chartConfiguration.chartData,
                                                   xStartField: xStartField,
                                                   xEndField: xEndField,
                                                   mode: modeX) {
            if isClick,
               chartConfiguration.interactionData.componentSelectedElementInRangeX[component] == dataItemRangeX {
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
                                                   yStartField: yStartField,
                                                   yEndField: yEndField,
                                                   mode: modeY) {
            if isClick,
               chartConfiguration.interactionData.componentSelectedElementInRangeY[component] == dataItemRangeY {
                chartConfiguration.interactionData.componentSelectedElementInRangeY[component] = nil
            } else {
                chartConfiguration.interactionData.componentSelectedElementInRangeY[component] = dataItemRangeY
            }

            if chartConfiguration.interactionData.componentSelectedElementInRangeX[component] == dataItemRangeY {
                if isClick,
                   chartConfiguration.interactionData.componentSelectedElementInXY[component] == dataItemRangeY {
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

    func updateInteractionOverlay(component: ChartComponent, isClick: Bool) {
        if let interactions = chartConfiguration.interactionData.componentInteraction[component] {
            for interaction in interactions {
                switch interaction {
                case let .click(action):
                    if isClick {
                        switch action {
                        case let .openURL(url):
                            if let _ = chartConfiguration.interactionData.componentSelectedElementInXY[component] {
                                UIApplication.shared.open(url)
                            }
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

    @ViewBuilder
    func chartInteractionHandler(proxy: ChartProxy) -> some View {
        GeometryReader { geo in
            Rectangle().fill(.clear).contentShape(Rectangle())
                .gesture(
                    SpatialTapGesture()
                        .onEnded { value in
                            let location = value.location
                            for component in chartConfiguration.components {
                                switch component {
                                case let .barMarkRepeat1(xStart, xEnd, y, _):
                                    updateInteractionData(component: component,
                                                          location: location,
                                                          proxy: proxy,
                                                          geo: geo,
                                                          xStartField: xStart.field,
                                                          xEndField: xEnd.field,
                                                          yStartField: y.field,
                                                          yEndField: y.field,
                                                          isClick: true)
                                case let .lineMarkRepeat1(x, y, _, _):
                                    updateInteractionData(component: component,
                                                          location: location,
                                                          proxy: proxy,
                                                          geo: geo,
                                                          xStartField: x.field,
                                                          xEndField: x.field,
                                                          yStartField: y.field,
                                                          yEndField: y.field,
                                                          isClick: true,
                                                          modeX: .nearest,
                                                          modeY: .accurate)
                                }
                                updateInteractionOverlay(component: component, isClick: true)
                            }
                        }
                        .exclusively(
                            before: DragGesture()
                                .onChanged { value in
                                    let location = value.location
                                    for component in chartConfiguration.components {
                                        switch component {
                                        case let .barMarkRepeat1(xStart, xEnd, y, _):
                                            updateInteractionData(component: component,
                                                                  location: location,
                                                                  proxy: proxy,
                                                                  geo: geo,
                                                                  xStartField: xStart.field,
                                                                  xEndField: xEnd.field,
                                                                  yStartField: y.field,
                                                                  yEndField: y.field,
                                                                  isClick: false)
                                        case let .lineMarkRepeat1(x, y, _, _):
                                            updateInteractionData(component: component,
                                                                  location: location,
                                                                  proxy: proxy,
                                                                  geo: geo,
                                                                  xStartField: x.field,
                                                                  xEndField: x.field,
                                                                  yStartField: y.field,
                                                                  yEndField: y.field,
                                                                  isClick: false,
                                                                  modeX: .nearest,
                                                                  modeY: .accurate)
                                        }
                                        updateInteractionOverlay(component: component, isClick: false)
                                    }
                                }
                        )
                )
        }
    }
}

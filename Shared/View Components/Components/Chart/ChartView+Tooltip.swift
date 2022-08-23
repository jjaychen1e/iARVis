//
//  ChartView+Tooltip.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/23.
//

import Charts
import Foundation
import SwiftUI
import SwiftyJSON

extension ChartView {
    @ViewBuilder
    func chartOverlayHandler(proxy: ChartProxy) -> some View {
        GeometryReader { geoProxy in
            let topOffset = -geoProxy.frame(in: .named("Widget")).origin.y
            ForEach(0 ..< chartConfiguration.components.count, id: \.self) { index in
                let component = chartConfiguration.components[index]
                let viewComponent: ViewElementComponent? = chartConfiguration.interactionData.componentSelectedElementView[component]
                if let viewComponent = viewComponent {
                    switch component {
                    case let .barMarkRepeat1(xStart, xEnd, y, _):
                        let selectedElement: JSON? = chartConfiguration.interactionData.componentSelectedElementInRangeX[component]
                        if let selectedElement = selectedElement {
                            if let leftPoint = proxy.position(at: (selectedElement[xStart.field], selectedElement[y.field])),
                               let rightPoint = proxy.position(at: (selectedElement[xEnd.field], selectedElement[y.field])) {
                                let centerPoint: CGPoint = (leftPoint + rightPoint) / 2
                                let targetSize: CGSize = ChartTooltipView(viewComponent).adaptiveSizeThatFits(in: .init(width: 250, height: 140), for: .regular)
                                let maxTooltipX: CGFloat = geoProxy.size.width - targetSize.width
                                let offsetX: CGFloat = min(maxTooltipX, max(0, centerPoint.x - targetSize.width / 2))
                                let offsetY: CGFloat = max(topOffset + 8, centerPoint.y - targetSize.height - 8)
                                ChartTooltipView(viewComponent)
                                    .frame(width: targetSize.width, height: targetSize.height)
                                    .offset(x: offsetX, y: offsetY)
                                    .id(selectedElement.rawString(options: []))
                            }
                        }
                    case let .lineMarkRepeat1(x, y, _, _):
                        let selectedElement: JSON? = chartConfiguration.interactionData.componentSelectedElementInRangeX[component]
                        if let selectedElement = selectedElement {
                            if let centerPoint = proxy.position(at: (selectedElement[x.field], selectedElement[y.field])){
                                let targetSize: CGSize = ChartTooltipView(viewComponent).adaptiveSizeThatFits(in: .init(width: 250, height: 140), for: .regular)
                                let maxTooltipX: CGFloat = geoProxy.size.width - targetSize.width
                                let offsetX: CGFloat = min(maxTooltipX, max(0, centerPoint.x - targetSize.width / 2))
                                let offsetY: CGFloat = max(topOffset + 8, centerPoint.y - targetSize.height - 8)
                                ChartTooltipView(viewComponent)
                                    .frame(width: targetSize.width, height: targetSize.height)
                                    .offset(x: offsetX, y: offsetY)
                                    .id(selectedElement.rawString(options: []))
                            }
                        }
                    }
                }
            }
        }
        .animation(.default, value: UUID())
        .transition(.opacity)
    }
}

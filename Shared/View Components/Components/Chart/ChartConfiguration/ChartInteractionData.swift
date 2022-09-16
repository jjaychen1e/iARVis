//
//  ChartInteractionData.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/27.
//

import Foundation
import SwiftyJSON

@available(iOS 16, *)
struct ChartInteractionHoverTooltipManualConfig: Equatable {
    var field: String
    var value: JSON
    var content: ViewElementComponent
}

enum ChartInteractionHoverTooltipType: String, RawRepresentable {
    case manual = "Manual"
    case auto = "Auto"
}

@available(iOS 16, *)
enum ChartInteractionHoverTooltip: Equatable {
    case manual(contents: [ChartInteractionHoverTooltipManualConfig])
    case auto(content: ViewElementComponent)
}

enum ChartInteractionClickActionType: String, RawRepresentable {
    case openURL = "OpenURL"
}

enum ChartInteractionClickAction: Equatable {
    case openURL(url: URL)
}

enum ChartInteractionType: String, RawRepresentable {
    case hover = "Hover"
    case click = "Click"
}

@available(iOS 16, *)
enum ChartInteraction: Equatable {
    case hover(tooltip: ChartInteractionHoverTooltip)
    case click(action: ChartInteractionClickAction)
}

@available(iOS 16, *)
class ChartInteractionData: Equatable, ObservableObject {
    static func == (lhs: ChartInteractionData, rhs: ChartInteractionData) -> Bool {
        lhs.componentSelectedElementInRangeX == rhs.componentSelectedElementInRangeX &&
        lhs.componentSelectedElementInRangeY == rhs.componentSelectedElementInRangeY &&
        lhs.componentSelectedElementInXY == rhs.componentSelectedElementInXY &&
        lhs.componentInteraction == rhs.componentInteraction &&
        lhs.componentSelectedElementView == rhs.componentSelectedElementView
    }
    
    @Published var componentSelectedElementInRangeX: [ChartComponent: JSON] = [:]
    @Published var componentSelectedElementInRangeY: [ChartComponent: JSON] = [:]
    @Published var componentSelectedElementInXY: [ChartComponent: JSON] = [:]
    @Published var componentInteraction: [ChartComponent: [ChartInteraction]] = [:]
    @Published var componentSelectedElementView: [ChartComponent: ViewElementComponent] = [:]

    init() {}

    init(componentInteraction: [ChartComponent: [ChartInteraction]]) {
        self.componentInteraction = componentInteraction
    }
}

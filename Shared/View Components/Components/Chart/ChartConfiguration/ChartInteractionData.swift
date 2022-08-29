//
//  ChartInteractionData.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/27.
//

import Foundation
import SwiftyJSON

struct ChartInteractionHoverTooltipManualConfig: Equatable {
    var field: String
    var value: JSON
    var content: ViewElementComponent
}

enum ChartInteractionHoverTooltipType: String, RawRepresentable {
    case manual = "Manual"
    case auto = "Auto"
}

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

enum ChartInteraction: Equatable {
    case hover(tooltip: ChartInteractionHoverTooltip)
    case click(action: ChartInteractionClickAction)
}

struct ChartInteractionData: Equatable {
    var componentSelectedElementInRangeX: [ChartComponent: JSON] = [:]
    var componentSelectedElementInRangeY: [ChartComponent: JSON] = [:]
    var componentSelectedElementInXY: [ChartComponent: JSON] = [:]
    var componentInteraction: [ChartComponent: [ChartInteraction]] = [:]
    var componentSelectedElementView: [ChartComponent: ViewElementComponent] = [:]

    init() {}

    init(componentInteraction: [ChartComponent: [ChartInteraction]]) {
        self.componentInteraction = componentInteraction
    }
}

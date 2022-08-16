//
//  ChartConfiguration.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/14.
//

import Foundation
import SwiftUI
import SwiftyJSON

struct ChartConfiguration: Codable {
    var chartData = ChartData()
    var components: [ChartComponent] = []
    var interactionData = ChartInteractionData()
    var chartXScale = ChartXScale()
    var styleConfiguration = ChartStyleConfiguration()

    init(chartData: ChartData = .init(), components: [ChartComponent] = [], chartXScale: ChartXScale = .init(), styleConfiguration: ChartStyleConfiguration = ChartStyleConfiguration()) {
        self.chartData = chartData
        self.components = components
        self.chartXScale = chartXScale
        self.styleConfiguration = styleConfiguration
        interactionData = ChartInteractionData()
    }
}

struct ChartData: Codable {
    let data: JSON
    let titles: [String]
    let length: Int

    init(data: JSON? = nil, titles: [String]? = nil) {
        let data = data ?? JSON()
        self.data = data

        if let titles = titles {
            self.titles = titles
        } else {
            if let keys = data.dictionary?.keys {
                self.titles = Array(keys)
            } else {
                self.titles = []
            }
        }

        var maxLength = 0
        for title in self.titles {
            if let array = data[title].array {
                maxLength = max(maxLength, array.count)
            }
        }
        length = maxLength
    }
}

struct ChartXScale: Codable {
    var includingZero: Bool?
    var domain: [JSON]?
}

struct ChartInteractionHoverTooltipManualConfig {
    var field: String
    var value: JSON
    var content: ViewElementComponent
}

enum ChartInteractionHoverTooltipType: String, RawRepresentable {
    case manual = "Manual"
    case auto = "Auto"
}

enum ChartInteractionHoverTooltip {
    case manual(contents: [ChartInteractionHoverTooltipManualConfig])
    case auto(content: ViewElementComponent)
}

enum ChartInteractionClickActionType: String, RawRepresentable {
    case openURL = "OpenURL"
}

enum ChartInteractionClickAction {
    case openURL(url: URL)
}

enum ChartInteractionType: String, RawRepresentable {
    case hover = "Hover"
    case click = "Click"
}

enum ChartInteraction {
    case hover(tooltip: ChartInteractionHoverTooltip)
    case click(action: ChartInteractionClickAction)
}

struct ChartInteractionData: Codable {
    var componentSelectedElementInRangeX: [ChartComponent: JSON] = [:]
    var componentSelectedElementInRangeY: [ChartComponent: JSON] = [:]
    var componentSelectedElementInXY: [ChartComponent: JSON] = [:]
    var componentInteraction: [ChartComponent: [ChartInteraction]] = [:]
    var componentSelectedElementView: [ChartComponent: ViewElementComponent] = [:]

    init() {}

    init(componentInteraction: [ChartComponent: [ChartInteraction]]) {
        self.componentInteraction = componentInteraction
    }

    // TODO: Codable?
    enum CodingKeys: CodingKey {}
}

struct ChartStyleConfiguration: Codable {
    var maxWidth: CGFloat?
    var maxHeight: CGFloat?
}

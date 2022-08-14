//
//  ChartConfiguration.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/14.
//

import Foundation
import SwiftyJSON
import SwiftUI

struct ChartConfiguration: Codable {
    var chartData: ChartData
    var components: [ChartComponent] = []
    var interactionData = ChartInteractionData()
    var chartXScale: ChartXScale = .init()
    var styleConfiguration = ChartStyleConfiguration()

    init(chartData: ChartData, components: [ChartComponent] = [], chartXScale: ChartXScale = .init(), styleConfiguration: ChartStyleConfiguration = ChartStyleConfiguration()) {
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

    init(data: JSON, titles: [String]? = nil) {
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

struct ChartInteractionData: Codable {
    var componentSelectedElement: [ChartComponent: JSON] = [:]
    var componentElementSelectedView: [ChartComponent: AnyView] = [:]

    init() {}

    enum CodingKeys: CodingKey {
        case componentSelectedElement
    }

    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<ChartInteractionData.CodingKeys> = try decoder.container(keyedBy: ChartInteractionData.CodingKeys.self)

        componentSelectedElement = try container.decode([ChartComponent: JSON].self, forKey: ChartInteractionData.CodingKeys.componentSelectedElement)
    }

    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<ChartInteractionData.CodingKeys> = encoder.container(keyedBy: ChartInteractionData.CodingKeys.self)

        try container.encode(componentSelectedElement, forKey: ChartInteractionData.CodingKeys.componentSelectedElement)
    }
}

struct ChartStyleConfiguration: Codable {
    var maxWidth: CGFloat?
    var maxHeight: CGFloat?
}

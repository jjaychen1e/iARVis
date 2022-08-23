//
//  WidgetConfiguration.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/19.
//

import Foundation
import SwiftUI
import SceneKit

struct AdditionalWidgetConfiguration: Codable {
    var hidden: Bool = false
    var key: String
    var widgetConfiguration: WidgetConfiguration
}

class WidgetConfiguration: Codable, ObservableObject {
    var component: ViewElementComponent
    var relativeAnchorPoint: WidgetAnchorPoint
    var relativePosition: SCNVector3
    var positionOffset: SCNVector3 = .init(x: 0, y: 0, z: 0)
    var size: CGSize = .init(width: 1024, height: 768)
    var additionalWidgetConfiguration: [String: AdditionalWidgetConfiguration] = [:]

    enum CodingKeys: CodingKey {
        case relativeAnchorPoint
        case relativePosition
        case positionOffset
        case component
    }

    init(component: ViewElementComponent, relativeAnchorPoint: WidgetAnchorPoint, relativePosition: SCNVector3, positionOffset: SCNVector3 = .init(x: 0, y: 0, z: 0), size: CGSize = .init(width: 1024, height: 768)) {
        self.component = component
        self.relativeAnchorPoint = relativeAnchorPoint
        self.relativePosition = relativePosition
        self.positionOffset = positionOffset
        self.size = size
    }

    init(components: [ViewElementComponent] = [], relativeAnchorPoint: WidgetAnchorPoint, relativePosition: SCNVector3, positionOffset: SCNVector3 = .init(x: 0, y: 0, z: 0), size: CGSize = .init(width: 1024, height: 768)) {
        component = .vStack(elements: components)
        self.relativeAnchorPoint = relativeAnchorPoint
        self.relativePosition = relativePosition
        self.positionOffset = positionOffset
        self.size = size
    }
}

struct WidgetConfigurationEnvironmentKey: EnvironmentKey {
    static let defaultValue: WidgetConfiguration? = nil
}

extension EnvironmentValues {
    var widgetConfiguration: WidgetConfiguration? {
        get { self[WidgetConfigurationEnvironmentKey.self] }
        set { self[WidgetConfigurationEnvironmentKey.self] = newValue }
    }
}

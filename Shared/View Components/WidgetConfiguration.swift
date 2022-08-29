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
    var positionOffset: SCNVector3
    var size: CGSize
    var additionalWidgetConfiguration: [String: AdditionalWidgetConfiguration] = [:]

    enum CodingKeys: CodingKey {
        case relativeAnchorPoint
        case relativePosition
        case positionOffset
        case component
        case size
    }

    init(component: ViewElementComponent, relativeAnchorPoint: WidgetAnchorPoint, relativePosition: SCNVector3, positionOffset: SCNVector3 = .zero, size: CGSize = .init(width: 1024, height: 768), additionalWidgetConfiguration: [String: AdditionalWidgetConfiguration] = [:]) {
        self.component = component
        self.relativeAnchorPoint = relativeAnchorPoint
        self.relativePosition = relativePosition
        self.positionOffset = positionOffset
        self.size = size
        self.additionalWidgetConfiguration = additionalWidgetConfiguration
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

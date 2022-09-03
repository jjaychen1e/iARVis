//
//  WidgetConfiguration.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/19.
//

import DefaultCodable
import Foundation
import SceneKit
import SwiftUI

struct AdditionalWidgetConfiguration: Codable, Equatable {
    @Default<False>
    var hidden: Bool
    var key: String
    var widgetConfiguration: WidgetConfiguration
}

class WidgetConfiguration: Codable, Equatable, ObservableObject {
    var component: ViewElementComponent
    var relativeAnchorPoint: WidgetAnchorPoint
    var relativePosition: SCNVector3
    var positionOffset: SCNVector3
    var size: CGSize
    @Default<AdditionalWidgetConfigurationDefaultValueProvider>
    var additionalWidgetConfiguration: [String: AdditionalWidgetConfiguration]

    init(component: ViewElementComponent, relativeAnchorPoint: WidgetAnchorPoint, relativePosition: SCNVector3, positionOffset: SCNVector3 = .zero, size: CGSize = .init(width: 1024, height: 768), additionalWidgetConfiguration: [String: AdditionalWidgetConfiguration] = [:]) {
        self.component = component
        self.relativeAnchorPoint = relativeAnchorPoint
        self.relativePosition = relativePosition
        self.positionOffset = positionOffset
        self.size = size
        self.additionalWidgetConfiguration = additionalWidgetConfiguration
    }
    
    
    static func == (lhs: WidgetConfiguration, rhs: WidgetConfiguration) -> Bool {
        lhs.component == rhs.component &&
        lhs.relativeAnchorPoint == rhs.relativeAnchorPoint &&
        lhs.relativePosition == rhs.relativePosition &&
        lhs.positionOffset == rhs.positionOffset &&
        lhs.size == rhs.size &&
        lhs.additionalWidgetConfiguration == rhs.additionalWidgetConfiguration
    }

    enum AdditionalWidgetConfigurationDefaultValueProvider: DefaultValueProvider {
        typealias Value = [String: AdditionalWidgetConfiguration]

        static let `default`: [String: AdditionalWidgetConfiguration] = [:]
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

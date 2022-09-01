//
//  ChartConfiguration.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/14.
//

import Charts
import Foundation
import SwiftUI
import SwiftyJSON

struct ChartConfiguration {
    @available(iOS 16, *)
    init() {
        _chartData = ChartData()
        _componentConfigs = [ChartComponentConfiguration]()
        _interactionData = ChartInteractionData()
        _swiftChartConfiguration = SwiftChartConfiguration()
    }

    init(_chartData _: Any? = nil, _componentConfigs _: Any? = nil, _interactionData _: Any? = nil, _swiftChartConfiguration _: Any? = nil) {
        _chartData = nil
        _componentConfigs = nil
        _interactionData = nil
        _swiftChartConfiguration = nil
    }

    @available(iOS 16, *)
    var chartData: ChartData {
        get {
            _chartData as! ChartData
        }
        set {
            _chartData = newValue
        }
    }

    private var _chartData: Any?

    @available(iOS 16, *)
    var componentConfigs: [ChartComponentConfiguration] {
        get {
            _componentConfigs as! [ChartComponentConfiguration]
        }
        set {
            _componentConfigs = newValue
        }
    }

    private var _componentConfigs: Any?

    @available(iOS 16, *)
    var interactionData: ChartInteractionData {
        get {
            _interactionData as! ChartInteractionData
        }
        set {
            _interactionData = newValue
        }
    }

    private var _interactionData: Any?

    @available(iOS 16, *)
    var swiftChartConfiguration: SwiftChartConfiguration {
        get {
            _swiftChartConfiguration as! SwiftChartConfiguration
        }
        set {
            _swiftChartConfiguration = newValue
        }
    }

    private var _swiftChartConfiguration: Any?
}

extension ChartConfiguration: Equatable {
    static func == (lhs: ChartConfiguration, rhs: ChartConfiguration) -> Bool {
        if #available(iOS 16, *) {
            return lhs.chartData == rhs.chartData &&
                lhs.componentConfigs == rhs.componentConfigs &&
                lhs.interactionData == rhs.interactionData &&
                lhs.swiftChartConfiguration == rhs.swiftChartConfiguration
        } else {
            return true
        }
    }
}

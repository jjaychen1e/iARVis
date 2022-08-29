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
        _chartXScale = nil
        _chartXAxis = nil
        _chartYAxis = nil
        _styleConfiguration = nil
    }

    init(_chartData _: Any? = nil, _componentConfigs _: Any? = nil, _interactionData _: Any? = nil, _chartXScale _: Any? = nil, _chartXAxis _: Any? = nil, _chartYAxis _: Any? = nil, _styleConfiguration _: Any? = nil) {
        _chartData = nil
        _componentConfigs = nil
        _interactionData = nil
        _chartXScale = nil
        _chartXAxis = nil
        _chartYAxis = nil
        _styleConfiguration = nil
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
    var chartXScale: ChartXScale? {
        get {
            _chartXScale as? ChartXScale
        }
        set {
            _chartXScale = newValue
        }
    }

    private var _chartXScale: Any?

    @available(iOS 16, *)
    var chartXAxis: ChartXAxis? {
        get {
            _chartXAxis as? ChartXAxis
        }
        set {
            _chartXAxis = newValue
        }
    }

    private var _chartXAxis: Any?

    @available(iOS 16, *)
    var chartYAxis: ChartYAxis? {
        get {
            _chartYAxis as? ChartYAxis
        }
        set {
            _chartYAxis = newValue
        }
    }

    private var _chartYAxis: Any?

    @available(iOS 16, *)
    var styleConfiguration: ChartStyleConfiguration? {
        get {
            _styleConfiguration as? ChartStyleConfiguration
        }
        set {
            _styleConfiguration = newValue
        }
    }

    private var _styleConfiguration: Any?
}

extension ChartConfiguration: Equatable {
    static func == (lhs: ChartConfiguration, rhs: ChartConfiguration) -> Bool {
        if #available(iOS 16, *) {
            return lhs.chartData == rhs.chartData &&
                lhs.componentConfigs == rhs.componentConfigs &&
                lhs.interactionData == rhs.interactionData &&
                lhs.chartXScale == rhs.chartXScale &&
                lhs.chartXAxis == rhs.chartXAxis &&
                lhs.chartYAxis == rhs.chartYAxis &&
                lhs.styleConfiguration == rhs.styleConfiguration
        } else {
            return true
        }
    }
}

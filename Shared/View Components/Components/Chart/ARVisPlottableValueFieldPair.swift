//
//  ARVisPlottableValueFieldPair.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/14.
//

import Foundation
import SwiftyJSON
import Charts

struct ARVisPlottableValueFieldPair: Codable, Hashable {
    var label: String
    var field: String
//    TODO: var unit: ... to support date unit

    static func value(_ label: String, _ field: String) -> Self {
        ARVisPlottableValueFieldPair(label: label, field: field)
    }

    static func value(_ field: String) -> Self {
        ARVisPlottableValueFieldPair(label: field, field: field)
    }

    func plottableInt(_ json: JSON) -> PlottableValue<Int>? {
        if let intValue = json.int {
            return PlottableValue.value(label, intValue)
        }
        return nil
    }

    func plottableDouble(_ json: JSON) -> PlottableValue<Double>? {
        if let doubleValue = json.double {
            return PlottableValue.value(label, doubleValue)
        }
        return nil
    }

    func plottableDate(_ json: JSON) -> PlottableValue<Date>? {
        if let date = json.date {
            return PlottableValue.value(label, date)
        }
        return nil
    }

    func plottableString(_ json: JSON) -> PlottableValue<String>? {
        if let string = json.string {
            return PlottableValue.value(label, string)
        }
        return nil
    }
}

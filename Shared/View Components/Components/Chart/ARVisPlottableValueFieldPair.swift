//
//  ARVisPlottableValueFieldPair.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/14.
//

import Charts
import Foundation
import SwiftyJSON

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
        if let intValue = json.strictInt {
            return PlottableValue.value(label, intValue)
        }
        return nil
    }

    func plottableDouble(_ json: JSON) -> PlottableValue<Double>? {
        if let doubleValue = json.strictDouble {
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

fileprivate extension NSNumber {
    func toSwiftType() -> Any {
        switch CFNumberGetType(self as CFNumber) {
        case .charType:
            return boolValue
        case .sInt8Type, .sInt16Type, .sInt32Type, .sInt64Type, .shortType, .intType, .longType, .longLongType, .cfIndexType, .nsIntegerType:
            return intValue
        case .float32Type, .float64Type, .floatType, .doubleType, .cgFloatType:
            return doubleValue
        @unknown default:
            return self
        }
    }
}

extension JSON {
    var strictInt: Int? {
        if let number = number,
           let int = number.toSwiftType() as? Int {
            return int
        }
        return nil
    }
    
    var strictDouble: Double? {
        if let number = number,
           let double = number.toSwiftType() as? Double {
            return double
        }
        return nil
    }
}

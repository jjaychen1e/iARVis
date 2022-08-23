//
//  ARVisSymbol.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/23.
//

import Charts
import Foundation

enum ARVisSymbol: String, RawRepresentable, Codable {
    case circle = "Circle"
    case square = "Square"
    case triangle = "Triangle"
    case diamond = "Diamond"
    case pentagon = "Pentagon"
    case plus = "Plus"
    case cross = "Cross"
    case asterisk = "Asterisk"
}

extension ARVisSymbol {
    var symbol: some ChartSymbolShape {
        switch self {
        case .circle:
            return BuiltinChartSymbolShape.circle
        case .square:
            return BuiltinChartSymbolShape.square
        case .triangle:
            return BuiltinChartSymbolShape.triangle
        case .diamond:
            return BuiltinChartSymbolShape.diamond
        case .pentagon:
            return BuiltinChartSymbolShape.pentagon
        case .plus:
            return BuiltinChartSymbolShape.plus
        case .cross:
            return BuiltinChartSymbolShape.cross
        case .asterisk:
            return BuiltinChartSymbolShape.asterisk
        }
    }
}

//
//  ChartComponent.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/14.
//

import Charts
import Foundation
import SwiftUI
import SwiftyJSON

@available(iOS 16, *)
enum ChartComponent: Hashable {
    case barMarkRepeat1(dataKey: String, xStart: ARVisPlottableValueFieldPair, xEnd: ARVisPlottableValueFieldPair, y: ARVisPlottableValueFieldPair, height: CGFloat?)
    case barMarkRepeat2(dataKey: String, x: ARVisPlottableValueFieldPair, y: ARVisPlottableValueFieldPair, height: CGFloat?)
    case lineMarkRepeat1(dataKey: String, x: ARVisPlottableValueFieldPair, y: ARVisPlottableValueFieldPair)
    case lineMarkRepeat2(dataKey: String, x: ARVisPlottableValueFieldPair, ySeries: [ARVisPlottableValueFieldPair])
    case rectangleMarkRepeat1(dataKey: String, xStart: ARVisPlottableValueFieldPair, xEnd: ARVisPlottableValueFieldPair, yStart: ARVisPlottableValueFieldPair, yEnd: ARVisPlottableValueFieldPair)
    case ruleMarkRepeat1(dataKey: String, x: ARVisPlottableValueFieldPair, yStart: ARVisPlottableValueFieldPair? = nil, yEnd: ARVisPlottableValueFieldPair? = nil)
    case pointMarkRepeat1(dataKey: String, x: ARVisPlottableValueFieldPair, y: ARVisPlottableValueFieldPair)

    var dataKey: String {
        switch self {
        case let .barMarkRepeat1(dataKey, _, _, _, _):
            return dataKey
        case let .barMarkRepeat2(dataKey, _, _, _):
            return dataKey
        case let .lineMarkRepeat1(dataKey, _, _):
            return dataKey
        case let .lineMarkRepeat2(dataKey, _, _):
            return dataKey
        case let .rectangleMarkRepeat1(dataKey, _, _, _, _):
            return dataKey
        case let .ruleMarkRepeat1(dataKey, _, _, _):
            return dataKey
        case let .pointMarkRepeat1(dataKey, _, _):
            return dataKey
        }
    }
}

enum ChartComponentType: String, RawRepresentable {
    case barMark = "BarMark"
    case lineMark = "LineMark"
    case rectangleMark = "RectangleMark"
    case ruleMark = "RuleMark"
    case pointMark = "PointMark"
}

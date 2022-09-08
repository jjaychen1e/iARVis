//
//  ChartComponentCommonConfig.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/27.
//

import Foundation
import SwiftyJSON

struct ChartComponentCommonConfig: Codable, Equatable {
    var interpolationMethod: ARVisInterpolationMethod?
    var symbol: ARVisSymbol?
    var symbolSize: ARVisSymbolSize?
    var foregroundStyleColor: ARVisColor?
    var foregroundStyleColorMap: [ColorMap]?
    var foregroundStyleField: String?
    var foregroundStyleValue: String?
    var positionByValue: String?
    var cornerRadius: CGFloat?
    var lineStyle: ARVisLineStyle?
    var annotations: [ARVisAnnotation]?
    var conditionalAnnotations: [ARVisConditionalAnnotation]?
}

struct ColorMap: Codable, Equatable {
    var field: String
    var value: JSON
    var color: ARVisColor
}

//
//  ChartComponentCommonConfig.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/27.
//

import Foundation

enum ChartComponentCommonConfigType: String, RawRepresentable, CaseIterable {
    case interpolationMethod
    case symbol
    case foregroundStyleColor
    case lineStyle
    case annotation
}

@available(iOS 16, *)
struct ChartComponentCommonConfig: Codable, Equatable {
    var interpolationMethod: ARVisInterpolationMethod?
    var symbol: ARVisSymbol?
    var symbolSize: ARVisSymbolSize?
    var foregroundStyleColor: ARVisColor?
    var lineStyle: ARVisLineStyle?
    var annotation: ARVisAnnotation?
}

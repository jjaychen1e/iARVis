//
//  ChartComponentCommonConfig.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/27.
//

import Foundation

@available(iOS 16, *)
struct ChartComponentCommonConfig: Codable, Equatable {
    var interpolationMethod: ARVisInterpolationMethod?
    var symbol: ARVisSymbol?
    var symbolSize: ARVisSymbolSize?
    var foregroundStyleColor: ARVisColor?
    var foregroundStyleField: String?
    var foregroundStyleValue: String?
    var lineStyle: ARVisLineStyle?
    var annotations: [ARVisAnnotation]?
    var conditionalAnnotations: [ARVisConditionalAnnotation]?
}

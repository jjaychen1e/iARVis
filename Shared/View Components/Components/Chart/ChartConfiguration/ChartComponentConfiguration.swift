//
//  ChartComponentConfiguration.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/27.
//

import Foundation
import Charts

struct ChartComponentConfiguration: Codable, Equatable {
    var component: ChartComponent
    var commonConfig: ChartComponentCommonConfig

    @ChartContentBuilder
    func toChartContent(configuration: ChartConfiguration) -> some ChartContent {
        component.toChartContent(configuration: configuration)
            .if(commonConfig.interpolationMethod != nil) { view in
                if let interpolationMethod = commonConfig.interpolationMethod {
                    view.interpolationMethod(.init(interpolationMethod))
                }
            }
            .if(commonConfig.symbol != nil) { view in
                if let symbol = commonConfig.symbol {
                    view.symbol(symbol.type.symbol)
                }
            }
            .if(commonConfig.foregroundStyleColor != nil) { view in
                if let foregroundStyleColor = commonConfig.foregroundStyleColor {
                    view.foregroundStyle(foregroundStyleColor.toSwiftUIColor())
                }
            }
            .if(commonConfig.lineStyle != nil) { view in
                if let lineStyle = commonConfig.lineStyle {
                    view.lineStyle(.init(lineStyle))
                }
            }
            .if(commonConfig.annotation != nil) { view in
                if let annotation = commonConfig.annotation {
                    view.annotation(position: .init(annotation.position)) {
                        annotation.content.view()
                    }
                }
            }
            .if(commonConfig.symbolSize != nil) { view in
                if let symbolSize = commonConfig.symbolSize {
                    view.symbolSize(.init(symbolSize))
                }
            }
    }
}

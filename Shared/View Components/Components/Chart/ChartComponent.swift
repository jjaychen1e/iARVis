//
//  ChartComponent.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/14.
//

import Foundation
import SwiftUI
import Charts

enum ChartComponent: Codable, Hashable {
    case barMarkRepeat1(xStart: ARVisPlottableValueFieldPair, xEnd: ARVisPlottableValueFieldPair, y: ARVisPlottableValueFieldPair, height: CGFloat)
}

extension ChartComponent {
    @ChartContentBuilder
    func toChartContent(configuration: ChartConfiguration) -> some ChartContent {
        switch self {
        case let .barMarkRepeat1(xStart, xEnd, y, height):
            ForEach(0 ..< configuration.chartData.length, id: \.self) { index in
                if let xStartJSONValue = configuration.chartData.data[xStart.field].array?[safe: index],
                   let xEndJSONValue = configuration.chartData.data[xEnd.field].array?[safe: index],
                   let yJSONValue = configuration.chartData.data[y.field].array?[safe: index] {
                    // Possible case:
                    // Int, String; Int, Int; Int, Double; Int, Date;
                    // Double, String; Double, Int; Double, Double; Double, Date;
                    // Date, String; Date, Int; Date, Double; Date, Date;
                    if let xStartIntValue = xStart.plottableInt(xStartJSONValue), let xEndIntValue = xEnd.plottableInt(xEndJSONValue) {
                        if let yIntValue = y.plottableInt(yJSONValue) {
                            BarMark(xStart: xStartIntValue, xEnd: xEndIntValue, y: yIntValue, height: .fixed(height))
                        } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                            BarMark(xStart: xStartIntValue, xEnd: xEndIntValue, y: yDoubleValue, height: .fixed(height))
                        } else if let yDateValue = y.plottableDate(yJSONValue) {
                            BarMark(xStart: xStartIntValue, xEnd: xEndIntValue, y: yDateValue, height: .fixed(height))
                        } else if let yStringValue = y.plottableString(yJSONValue) {
                            BarMark(xStart: xStartIntValue, xEnd: xEndIntValue, y: yStringValue, height: .fixed(height))
                        }
                    } else if let xStartDoubleValue = xStart.plottableDouble(xStartJSONValue), let xEndDoubleValue = xEnd.plottableDouble(xEndJSONValue) {
                        if let yIntValue = y.plottableInt(yJSONValue) {
                            BarMark(xStart: xStartDoubleValue, xEnd: xEndDoubleValue, y: yIntValue, height: .fixed(height))
                        } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                            BarMark(xStart: xStartDoubleValue, xEnd: xEndDoubleValue, y: yDoubleValue, height: .fixed(height))
                        } else if let yDateValue = y.plottableDate(yJSONValue) {
                            BarMark(xStart: xStartDoubleValue, xEnd: xEndDoubleValue, y: yDateValue, height: .fixed(height))
                        } else if let yStringValue = y.plottableString(yJSONValue) {
                            BarMark(xStart: xStartDoubleValue, xEnd: xEndDoubleValue, y: yStringValue, height: .fixed(height))
                        }
                    } else if let xStartDateValue = xStart.plottableDate(xStartJSONValue), let xEndDateValue = xEnd.plottableDate(xEndJSONValue) {
                        if let yIntValue = y.plottableInt(yJSONValue) {
                            BarMark(xStart: xStartDateValue, xEnd: xEndDateValue, y: yIntValue, height: .fixed(height))
                        } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                            BarMark(xStart: xStartDateValue, xEnd: xEndDateValue, y: yDoubleValue, height: .fixed(height))
                        } else if let yDateValue = y.plottableDate(yJSONValue) {
                            BarMark(xStart: xStartDateValue, xEnd: xEndDateValue, y: yDateValue, height: .fixed(height))
                        } else if let yStringValue = y.plottableString(yJSONValue) {
                            BarMark(xStart: xStartDateValue, xEnd: xEndDateValue, y: yStringValue, height: .fixed(height))
                        }
                    }
                }
            }
        }
    }
}

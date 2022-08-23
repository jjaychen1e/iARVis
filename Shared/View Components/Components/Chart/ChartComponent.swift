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

enum ChartComponent: Codable, Hashable {
    case barMarkRepeat1(xStart: ARVisPlottableValueFieldPair, xEnd: ARVisPlottableValueFieldPair, y: ARVisPlottableValueFieldPair, height: CGFloat?)
    case lineMarkRepeat1(x: ARVisPlottableValueFieldPair, y: ARVisPlottableValueFieldPair, interpolationMethod: ARVisInterpolationMethod, symbol: ARVisSymbol?)
}

enum ChartComponentType: String, RawRepresentable {
    case barMark = "BarMark"
    case lineMark = "LineMark"
}

enum ChartComponentHoverType {
    case rangeX
    case rangeY
    case xy
}

extension ChartComponent {
    var hoverType: ChartComponentHoverType {
        switch self {
        case .barMarkRepeat1:
            return .rangeX
        case .lineMarkRepeat1:
            return .rangeX
        }
    }
}

extension ChartComponent {
    private func barMark<X: Plottable, Y: Plottable>(xStart: PlottableValue<X>, xEnd: PlottableValue<X>, y: PlottableValue<Y>, height: CGFloat?) -> some ChartContent {
        BarMark(xStart: xStart, xEnd: xEnd, y: y, height: height != nil ? .fixed(height!) : .automatic)
    }

    private func lineMark<X: Plottable, Y: Plottable>(x: PlottableValue<X>, y: PlottableValue<Y>, interpolationMethod: ARVisInterpolationMethod, symbol: ARVisSymbol?) -> some ChartContent {
        LineMark(x: x, y: y)
            .interpolationMethod(.init(interpolationMethod))
            .if(symbol != nil) { view in
                view.symbol(symbol!.symbol)
            }
    }

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
                            barMark(xStart: xStartIntValue, xEnd: xEndIntValue, y: yIntValue, height: height)
                        } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                            barMark(xStart: xStartIntValue, xEnd: xEndIntValue, y: yDoubleValue, height: height)
                        } else if let yDateValue = y.plottableDate(yJSONValue) {
                            barMark(xStart: xStartIntValue, xEnd: xEndIntValue, y: yDateValue, height: height)
                        } else if let yStringValue = y.plottableString(yJSONValue) {
                            barMark(xStart: xStartIntValue, xEnd: xEndIntValue, y: yStringValue, height: height)
                        }
                    } else if let xStartDoubleValue = xStart.plottableDouble(xStartJSONValue), let xEndDoubleValue = xEnd.plottableDouble(xEndJSONValue) {
                        if let yIntValue = y.plottableInt(yJSONValue) {
                            barMark(xStart: xStartDoubleValue, xEnd: xEndDoubleValue, y: yIntValue, height: height)
                        } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                            barMark(xStart: xStartDoubleValue, xEnd: xEndDoubleValue, y: yDoubleValue, height: height)
                        } else if let yDateValue = y.plottableDate(yJSONValue) {
                            barMark(xStart: xStartDoubleValue, xEnd: xEndDoubleValue, y: yDateValue, height: height)
                        } else if let yStringValue = y.plottableString(yJSONValue) {
                            barMark(xStart: xStartDoubleValue, xEnd: xEndDoubleValue, y: yStringValue, height: height)
                        }
                    } else if let xStartDateValue = xStart.plottableDate(xStartJSONValue), let xEndDateValue = xEnd.plottableDate(xEndJSONValue) {
                        if let yIntValue = y.plottableInt(yJSONValue) {
                            barMark(xStart: xStartDateValue, xEnd: xEndDateValue, y: yIntValue, height: height)
                        } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                            barMark(xStart: xStartDateValue, xEnd: xEndDateValue, y: yDoubleValue, height: height)
                        } else if let yDateValue = y.plottableDate(yJSONValue) {
                            barMark(xStart: xStartDateValue, xEnd: xEndDateValue, y: yDateValue, height: height)
                        } else if let yStringValue = y.plottableString(yJSONValue) {
                            barMark(xStart: xStartDateValue, xEnd: xEndDateValue, y: yStringValue, height: height)
                        }
                    }
                }
            }
        case let .lineMarkRepeat1(x, y, interpolationMethod, symbol):
            ForEach(0 ..< configuration.chartData.length, id: \.self) { index in
                if let xJSONValue = configuration.chartData.data[x.field].array?[safe: index],
                   let yJSONValue = configuration.chartData.data[y.field].array?[safe: index] {
                    // Possible case:
                    //  Int, Int; Int, Double; Int, Date;
                    //  Double, Int; Double, Double; Double, Date;
                    //  Date, Int; Date, Double; Date, Date;
                    //  String, Int; String, Double; String, Date;
                    if let xIntValue = x.plottableInt(xJSONValue) {
                        if let yIntValue = y.plottableInt(yJSONValue) {
                            lineMark(x: xIntValue, y: yIntValue, interpolationMethod: interpolationMethod, symbol: symbol)
                        } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                            lineMark(x: xIntValue, y: yDoubleValue, interpolationMethod: interpolationMethod, symbol: symbol)
                        } else if let yDateValue = y.plottableDate(yJSONValue) {
                            lineMark(x: xIntValue, y: yDateValue, interpolationMethod: interpolationMethod, symbol: symbol)
                        }
                    } else if let xDoubleValue = x.plottableDouble(xJSONValue) {
                        if let yIntValue = y.plottableInt(yJSONValue) {
                            lineMark(x: xDoubleValue, y: yIntValue, interpolationMethod: interpolationMethod, symbol: symbol)
                        } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                            lineMark(x: xDoubleValue, y: yDoubleValue, interpolationMethod: interpolationMethod, symbol: symbol)
                        } else if let yDateValue = y.plottableDate(yJSONValue) {
                            lineMark(x: xDoubleValue, y: yDateValue, interpolationMethod: interpolationMethod, symbol: symbol)
                        }
                    } else if let xDateValue = x.plottableDate(xJSONValue) {
                        if let yIntValue = y.plottableInt(yJSONValue) {
                            lineMark(x: xDateValue, y: yIntValue, interpolationMethod: interpolationMethod, symbol: symbol)
                        } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                            lineMark(x: xDateValue, y: yDoubleValue, interpolationMethod: interpolationMethod, symbol: symbol)
                        } else if let yDateValue = y.plottableDate(yJSONValue) {
                            lineMark(x: xDateValue, y: yDateValue, interpolationMethod: interpolationMethod, symbol: symbol)
                        }
                    } else if let xStringValue = x.plottableString(xJSONValue) {
                        if let yIntValue = y.plottableInt(yJSONValue) {
                            lineMark(x: xStringValue, y: yIntValue, interpolationMethod: interpolationMethod, symbol: symbol)
                        } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                            lineMark(x: xStringValue, y: yDoubleValue, interpolationMethod: interpolationMethod, symbol: symbol)
                        } else if let yDateValue = y.plottableDate(yJSONValue) {
                            lineMark(x: xStringValue, y: yDateValue, interpolationMethod: interpolationMethod, symbol: symbol)
                        }
                    }
                }
            }
        }
    }
}

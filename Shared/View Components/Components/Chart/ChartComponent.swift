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
enum ChartComponent: Codable, Hashable {
    case barMarkRepeat1(dataKey: String, xStart: ARVisPlottableValueFieldPair, xEnd: ARVisPlottableValueFieldPair, y: ARVisPlottableValueFieldPair, height: CGFloat?)
    case lineMarkRepeat1(dataKey: String, x: ARVisPlottableValueFieldPair, y: ARVisPlottableValueFieldPair)
    case rectangleMarkRepeat1(dataKey: String, xStart: ARVisPlottableValueFieldPair, xEnd: ARVisPlottableValueFieldPair, yStart: ARVisPlottableValueFieldPair, yEnd: ARVisPlottableValueFieldPair)
    case ruleMarkRepeat1(dataKey: String, x: ARVisPlottableValueFieldPair, yStart: ARVisPlottableValueFieldPair? = nil, yEnd: ARVisPlottableValueFieldPair? = nil)
    case pointMarkRepeat1(dataKey: String, x: ARVisPlottableValueFieldPair, y: ARVisPlottableValueFieldPair)

    var dataKey: String {
        switch self {
        case let .barMarkRepeat1(dataKey, _, _, _, _):
            return dataKey
        case let .lineMarkRepeat1(dataKey, _, _):
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

enum ChartComponentHoverType {
    case rangeX
    case rangeY
    case xy
}

@available(iOS 16, *)
extension ChartComponent {
    var hoverType: ChartComponentHoverType {
        switch self {
        case .barMarkRepeat1:
            return .rangeX
        case .lineMarkRepeat1:
            return .rangeX
        case .rectangleMarkRepeat1:
            return .rangeX
        case .ruleMarkRepeat1:
            return .rangeX
        case .pointMarkRepeat1:
            return .xy
        }
    }
}

@available(iOS 16, *)
extension ChartComponent {
    @ChartContentBuilder
    private func applyCommonConfig<Content: ChartContent>(_ content: Content, commonConfig: ChartComponentCommonConfig, datum: JSON) -> some ChartContent {
        content
            .if(commonConfig.foregroundStyleField != nil) { view in
                if let foregroundStyleField = commonConfig.foregroundStyleField,
                   let data = datum[foregroundStyleField].string {
                    view.foregroundStyle(by: .value(foregroundStyleField, data))
                } else {
                    view
                }
            }
    }

    private func barMark<X: Plottable, Y: Plottable>(xStart: PlottableValue<X>, xEnd: PlottableValue<X>, y: PlottableValue<Y>, height: CGFloat?) -> some ChartContent {
        BarMark(xStart: xStart, xEnd: xEnd, y: y, height: height != nil ? .fixed(height!) : .automatic)
    }

    private func lineMark<X: Plottable, Y: Plottable>(x: PlottableValue<X>, y: PlottableValue<Y>) -> some ChartContent {
        LineMark(x: x, y: y)
    }

    private func rectangleMark<X: Plottable, Y: Plottable>(xStart: PlottableValue<X>, xEnd: PlottableValue<X>, yStart: PlottableValue<Y>, yEnd: PlottableValue<Y>) -> some ChartContent {
        RectangleMark(xStart: xStart, xEnd: xEnd, yStart: yStart, yEnd: yEnd)
    }

    private func ruleMark<X: Plottable>(x: PlottableValue<X>) -> some ChartContent {
        RuleMark(x: x)
    }

    private func ruleMark<X: Plottable, Y: Plottable>(x: PlottableValue<X>, yStart: PlottableValue<Y>, yEnd: PlottableValue<Y>) -> some ChartContent {
        RuleMark(x: x, yStart: yStart, yEnd: yEnd)
    }

    private func pointMark<X: Plottable, Y: Plottable>(x: PlottableValue<X>, y: PlottableValue<Y>) -> some ChartContent {
        PointMark(x: x, y: y)
    }

    @ChartContentBuilder
    private func barMarkRepeat1(configuration: ChartConfiguration, commonConfig: ChartComponentCommonConfig, dataItem: ChartDataItem, xStart: ARVisPlottableValueFieldPair, xEnd: ARVisPlottableValueFieldPair, y: ARVisPlottableValueFieldPair, height: CGFloat?) -> some ChartContent {
        ForEach(0 ..< dataItem.length, id: \.self) { index in
            let datum = dataItem.datum(at: index)
            if let xStartJSONValue = datum[xStart.field],
               let xEndJSONValue = datum[xEnd.field],
               let yJSONValue = datum[y.field] {
                // Possible case:
                // Int, String; Int, Int; Int, Double; Int, Date;
                // Double, String; Double, Int; Double, Double; Double, Date;
                // Date, String; Date, Int; Date, Double; Date, Date;
                if let xStartIntValue = xStart.plottableInt(xStartJSONValue), let xEndIntValue = xEnd.plottableInt(xEndJSONValue) {
                    if let yIntValue = y.plottableInt(yJSONValue) {
                        applyCommonConfig(barMark(xStart: xStartIntValue, xEnd: xEndIntValue, y: yIntValue, height: height), commonConfig: commonConfig, datum: datum)
                    } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                        applyCommonConfig(barMark(xStart: xStartIntValue, xEnd: xEndIntValue, y: yDoubleValue, height: height), commonConfig: commonConfig, datum: datum)
                    } else if let yDateValue = y.plottableDate(yJSONValue) {
                        applyCommonConfig(barMark(xStart: xStartIntValue, xEnd: xEndIntValue, y: yDateValue, height: height), commonConfig: commonConfig, datum: datum)
                    } else if let yStringValue = y.plottableString(yJSONValue) {
                        applyCommonConfig(barMark(xStart: xStartIntValue, xEnd: xEndIntValue, y: yStringValue, height: height), commonConfig: commonConfig, datum: datum)
                    }
                } else if let xStartDoubleValue = xStart.plottableDouble(xStartJSONValue), let xEndDoubleValue = xEnd.plottableDouble(xEndJSONValue) {
                    if let yIntValue = y.plottableInt(yJSONValue) {
                        applyCommonConfig(barMark(xStart: xStartDoubleValue, xEnd: xEndDoubleValue, y: yIntValue, height: height), commonConfig: commonConfig, datum: datum)
                    } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                        applyCommonConfig(barMark(xStart: xStartDoubleValue, xEnd: xEndDoubleValue, y: yDoubleValue, height: height), commonConfig: commonConfig, datum: datum)
                    } else if let yDateValue = y.plottableDate(yJSONValue) {
                        applyCommonConfig(barMark(xStart: xStartDoubleValue, xEnd: xEndDoubleValue, y: yDateValue, height: height), commonConfig: commonConfig, datum: datum)
                    } else if let yStringValue = y.plottableString(yJSONValue) {
                        applyCommonConfig(barMark(xStart: xStartDoubleValue, xEnd: xEndDoubleValue, y: yStringValue, height: height), commonConfig: commonConfig, datum: datum)
                    }
                } else if let xStartDateValue = xStart.plottableDate(xStartJSONValue), let xEndDateValue = xEnd.plottableDate(xEndJSONValue) {
                    if let yIntValue = y.plottableInt(yJSONValue) {
                        applyCommonConfig(barMark(xStart: xStartDateValue, xEnd: xEndDateValue, y: yIntValue, height: height), commonConfig: commonConfig, datum: datum)
                    } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                        applyCommonConfig(barMark(xStart: xStartDateValue, xEnd: xEndDateValue, y: yDoubleValue, height: height), commonConfig: commonConfig, datum: datum)
                    } else if let yDateValue = y.plottableDate(yJSONValue) {
                        applyCommonConfig(barMark(xStart: xStartDateValue, xEnd: xEndDateValue, y: yDateValue, height: height), commonConfig: commonConfig, datum: datum)
                    } else if let yStringValue = y.plottableString(yJSONValue) {
                        applyCommonConfig(barMark(xStart: xStartDateValue, xEnd: xEndDateValue, y: yStringValue, height: height), commonConfig: commonConfig, datum: datum)
                    }
                }
            }
        }
    }

    @ChartContentBuilder
    private func lineMarkRepeat1(configuration: ChartConfiguration, commonConfig: ChartComponentCommonConfig, dataItem: ChartDataItem, x: ARVisPlottableValueFieldPair, y: ARVisPlottableValueFieldPair) -> some ChartContent {
        ForEach(0 ..< dataItem.length, id: \.self) { index in
            let datum = dataItem.datum(at: index)
            if let xJSONValue = datum[x.field],
               let yJSONValue = datum[y.field] {
                // Possible case:
                //  Int, Int; Int, Double; Int, Date;
                //  Double, Int; Double, Double; Double, Date;
                //  Date, Int; Date, Double; Date, Date;
                //  String, Int; String, Double; String, Date;
                if let xIntValue = x.plottableInt(xJSONValue) {
                    if let yIntValue = y.plottableInt(yJSONValue) {
                        applyCommonConfig(lineMark(x: xIntValue, y: yIntValue), commonConfig: commonConfig, datum: datum)
                    } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                        applyCommonConfig(lineMark(x: xIntValue, y: yDoubleValue), commonConfig: commonConfig, datum: datum)
                    } else if let yDateValue = y.plottableDate(yJSONValue) {
                        applyCommonConfig(lineMark(x: xIntValue, y: yDateValue), commonConfig: commonConfig, datum: datum)
                    }
                } else if let xDoubleValue = x.plottableDouble(xJSONValue) {
                    if let yIntValue = y.plottableInt(yJSONValue) {
                        applyCommonConfig(lineMark(x: xDoubleValue, y: yIntValue), commonConfig: commonConfig, datum: datum)
                    } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                        applyCommonConfig(lineMark(x: xDoubleValue, y: yDoubleValue), commonConfig: commonConfig, datum: datum)
                    } else if let yDateValue = y.plottableDate(yJSONValue) {
                        applyCommonConfig(lineMark(x: xDoubleValue, y: yDateValue), commonConfig: commonConfig, datum: datum)
                    }
                } else if let xDateValue = x.plottableDate(xJSONValue) {
                    if let yIntValue = y.plottableInt(yJSONValue) {
                        applyCommonConfig(lineMark(x: xDateValue, y: yIntValue), commonConfig: commonConfig, datum: datum)
                    } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                        applyCommonConfig(lineMark(x: xDateValue, y: yDoubleValue), commonConfig: commonConfig, datum: datum)
                    } else if let yDateValue = y.plottableDate(yJSONValue) {
                        applyCommonConfig(lineMark(x: xDateValue, y: yDateValue), commonConfig: commonConfig, datum: datum)
                    }
                } else if let xStringValue = x.plottableString(xJSONValue) {
                    if let yIntValue = y.plottableInt(yJSONValue) {
                        applyCommonConfig(lineMark(x: xStringValue, y: yIntValue), commonConfig: commonConfig, datum: datum)
                    } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                        applyCommonConfig(lineMark(x: xStringValue, y: yDoubleValue), commonConfig: commonConfig, datum: datum)
                    } else if let yDateValue = y.plottableDate(yJSONValue) {
                        applyCommonConfig(lineMark(x: xStringValue, y: yDateValue), commonConfig: commonConfig, datum: datum)
                    }
                }
            }
        }
    }

    @ChartContentBuilder
    private func rectangleMarkRepeat1(configuration: ChartConfiguration, commonConfig: ChartComponentCommonConfig, dataItem: ChartDataItem, xStart: ARVisPlottableValueFieldPair, xEnd: ARVisPlottableValueFieldPair, yStart: ARVisPlottableValueFieldPair, yEnd: ARVisPlottableValueFieldPair) -> some ChartContent {
        ForEach(0 ..< dataItem.length, id: \.self) { index in
            let datum = dataItem.datum(at: index)
            if let xStartJSONValue = datum[xStart.field],
               let xEndJSONValue = datum[xEnd.field],
               let yStartJSONValue = datum[yStart.field],
               let yEndJSONValue = datum[yEnd.field] {
                // Possible case:
                // Int, Int; Int, Double; Int, Date;
                // Double, Int; Double, Double; Double, Date;
                //  Date, Int; Date, Double; Date, Date;
                if let xStartIntValue = xStart.plottableInt(xStartJSONValue), let xEndIntValue = xEnd.plottableInt(xEndJSONValue) {
                    if let yStartIntValue = yStart.plottableInt(yStartJSONValue), let yEndIntValue = yEnd.plottableInt(yEndJSONValue) {
                        applyCommonConfig(rectangleMark(xStart: xStartIntValue, xEnd: xEndIntValue, yStart: yStartIntValue, yEnd: yEndIntValue), commonConfig: commonConfig, datum: datum)
                    } else if let yStartDoubleValue = yStart.plottableDouble(yStartJSONValue), let yEndDoubleValue = yEnd.plottableDouble(yEndJSONValue) {
                        applyCommonConfig(rectangleMark(xStart: xStartIntValue, xEnd: xEndIntValue, yStart: yStartDoubleValue, yEnd: yEndDoubleValue), commonConfig: commonConfig, datum: datum)
                    } else if let yStartDateValue = yStart.plottableDate(yStartJSONValue), let yEndDateValue = yEnd.plottableDate(yEndJSONValue) {
                        applyCommonConfig(rectangleMark(xStart: xStartIntValue, xEnd: xEndIntValue, yStart: yStartDateValue, yEnd: yEndDateValue), commonConfig: commonConfig, datum: datum)
                    }
                } else if let xStartDoubleValue = xStart.plottableDouble(xStartJSONValue), let xEndDoubleValue = xEnd.plottableDouble(xEndJSONValue) {
                    if let yStartIntValue = yStart.plottableInt(yStartJSONValue), let yEndIntValue = yEnd.plottableInt(yEndJSONValue) {
                        applyCommonConfig(rectangleMark(xStart: xStartDoubleValue, xEnd: xEndDoubleValue, yStart: yStartIntValue, yEnd: yEndIntValue), commonConfig: commonConfig, datum: datum)
                    } else if let yStartDoubleValue = yStart.plottableDouble(yStartJSONValue), let yEndDoubleValue = yEnd.plottableDouble(yEndJSONValue) {
                        applyCommonConfig(rectangleMark(xStart: xStartDoubleValue, xEnd: xEndDoubleValue, yStart: yStartDoubleValue, yEnd: yEndDoubleValue), commonConfig: commonConfig, datum: datum)
                    } else if let yStartDateValue = yStart.plottableDate(yStartJSONValue), let yEndDateValue = yEnd.plottableDate(yEndJSONValue) {
                        applyCommonConfig(rectangleMark(xStart: xStartDoubleValue, xEnd: xEndDoubleValue, yStart: yStartDateValue, yEnd: yEndDateValue), commonConfig: commonConfig, datum: datum)
                    }
                } else if let xStartDateValue = xStart.plottableDate(xStartJSONValue), let xEndDateValue = xEnd.plottableDate(xEndJSONValue) {
                    if let yStartIntValue = yStart.plottableInt(yStartJSONValue), let yEndIntValue = yEnd.plottableInt(yEndJSONValue) {
                        applyCommonConfig(rectangleMark(xStart: xStartDateValue, xEnd: xEndDateValue, yStart: yStartIntValue, yEnd: yEndIntValue), commonConfig: commonConfig, datum: datum)
                    } else if let yStartDoubleValue = yStart.plottableDouble(yStartJSONValue), let yEndDoubleValue = yEnd.plottableDouble(yEndJSONValue) {
                        applyCommonConfig(rectangleMark(xStart: xStartDateValue, xEnd: xEndDateValue, yStart: yStartDoubleValue, yEnd: yEndDoubleValue), commonConfig: commonConfig, datum: datum)
                    } else if let yStartDateValue = yStart.plottableDate(yStartJSONValue), let yEndDateValue = yEnd.plottableDate(yEndJSONValue) {
                        applyCommonConfig(rectangleMark(xStart: xStartDateValue, xEnd: xEndDateValue, yStart: yStartDateValue, yEnd: yEndDateValue), commonConfig: commonConfig, datum: datum)
                    }
                }
            }
        }
    }

    @ChartContentBuilder
    private func ruleMarkRepeat1(configuration: ChartConfiguration, commonConfig: ChartComponentCommonConfig, dataItem: ChartDataItem, x: ARVisPlottableValueFieldPair, yStart: ARVisPlottableValueFieldPair?, yEnd: ARVisPlottableValueFieldPair?) -> some ChartContent {
        ForEach(0 ..< dataItem.length, id: \.self) { index in
            let datum = dataItem.datum(at: index)
            if let xJSONValue = datum[x.field] {
                // Possible case:
                // Int, nil; Int, Int; Int, Double; Int, Date;
                // Double, nil; Double, Int; Double, Double; Double, Date;
                // Date, nil; Date, Int; Date, Double; Date, Date;
                // String, nil; String, Int; String, Double; String, Date;
                if let xIntValue = x.plottableInt(xJSONValue) {
                    if yStart == nil || yEnd == nil {
                        ruleMark(x: xIntValue)
                    } else if let yStart = yStart,
                              let yEnd = yEnd,
                              let yStartJSONValue = datum[yStart.field],
                              let yEndJSONValue = datum[yEnd.field] {
                        if let yStartIntValue = yStart.plottableInt(yStartJSONValue), let yEndIntValue = yEnd.plottableInt(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xIntValue, yStart: yStartIntValue, yEnd: yEndIntValue), commonConfig: commonConfig, datum: datum)
                        } else if let yStartDoubleValue = yStart.plottableDouble(yStartJSONValue), let yEndDoubleValue = yEnd.plottableDouble(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xIntValue, yStart: yStartDoubleValue, yEnd: yEndDoubleValue), commonConfig: commonConfig, datum: datum)
                        } else if let yStartDateValue = yStart.plottableDate(yStartJSONValue), let yEndDateValue = yEnd.plottableDate(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xIntValue, yStart: yStartDateValue, yEnd: yEndDateValue), commonConfig: commonConfig, datum: datum)
                        }
                    }
                } else if let xDoubleValue = x.plottableDouble(xJSONValue) {
                    if yStart == nil || yEnd == nil {
                        applyCommonConfig(ruleMark(x: xDoubleValue), commonConfig: commonConfig, datum: datum)
                    } else if let yStart = yStart,
                              let yEnd = yEnd,
                              let yStartJSONValue = datum[yStart.field],
                              let yEndJSONValue = datum[yEnd.field] {
                        if let yStartIntValue = yStart.plottableInt(yStartJSONValue), let yEndIntValue = yEnd.plottableInt(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xDoubleValue, yStart: yStartIntValue, yEnd: yEndIntValue), commonConfig: commonConfig, datum: datum)
                        } else if let yStartDoubleValue = yStart.plottableDouble(yStartJSONValue), let yEndDoubleValue = yEnd.plottableDouble(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xDoubleValue, yStart: yStartDoubleValue, yEnd: yEndDoubleValue), commonConfig: commonConfig, datum: datum)
                        } else if let yStartDateValue = yStart.plottableDate(yStartJSONValue), let yEndDateValue = yEnd.plottableDate(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xDoubleValue, yStart: yStartDateValue, yEnd: yEndDateValue), commonConfig: commonConfig, datum: datum)
                        }
                    }
                } else if let xDateValue = x.plottableDate(xJSONValue) {
                    if yStart == nil || yEnd == nil {
                        applyCommonConfig(ruleMark(x: xDateValue), commonConfig: commonConfig, datum: datum)
                    } else if let yStart = yStart,
                              let yEnd = yEnd,
                              let yStartJSONValue = datum[yStart.field],
                              let yEndJSONValue = datum[yEnd.field] {
                        if let yStartIntValue = yStart.plottableInt(yStartJSONValue), let yEndIntValue = yEnd.plottableInt(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xDateValue, yStart: yStartIntValue, yEnd: yEndIntValue), commonConfig: commonConfig, datum: datum)
                        } else if let yStartDoubleValue = yStart.plottableDouble(yStartJSONValue), let yEndDoubleValue = yEnd.plottableDouble(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xDateValue, yStart: yStartDoubleValue, yEnd: yEndDoubleValue), commonConfig: commonConfig, datum: datum)
                        } else if let yStartDateValue = yStart.plottableDate(yStartJSONValue), let yEndDateValue = yEnd.plottableDate(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xDateValue, yStart: yStartDateValue, yEnd: yEndDateValue), commonConfig: commonConfig, datum: datum)
                        }
                    }
                } else if let xStringValue = x.plottableString(xJSONValue) {
                    if yStart == nil || yEnd == nil {
                        applyCommonConfig(ruleMark(x: xStringValue), commonConfig: commonConfig, datum: datum)
                    } else if let yStart = yStart,
                              let yEnd = yEnd,
                              let yStartJSONValue = datum[yStart.field],
                              let yEndJSONValue = datum[yEnd.field] {
                        if let yStartIntValue = yStart.plottableInt(yStartJSONValue), let yEndIntValue = yEnd.plottableInt(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xStringValue, yStart: yStartIntValue, yEnd: yEndIntValue), commonConfig: commonConfig, datum: datum)
                        } else if let yStartDoubleValue = yStart.plottableDouble(yStartJSONValue), let yEndDoubleValue = yEnd.plottableDouble(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xStringValue, yStart: yStartDoubleValue, yEnd: yEndDoubleValue), commonConfig: commonConfig, datum: datum)
                        } else if let yStartDateValue = yStart.plottableDate(yStartJSONValue), let yEndDateValue = yEnd.plottableDate(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xStringValue, yStart: yStartDateValue, yEnd: yEndDateValue), commonConfig: commonConfig, datum: datum)
                        }
                    }
                }
            }
        }
    }

    @ChartContentBuilder
    private func pointMarkRepeat1(configuration: ChartConfiguration, commonConfig: ChartComponentCommonConfig, dataItem: ChartDataItem, x: ARVisPlottableValueFieldPair, y: ARVisPlottableValueFieldPair) -> some ChartContent {
        ForEach(0 ..< dataItem.length, id: \.self) { index in
            let datum = dataItem.datum(at: index)
            if let xJSONValue = datum[x.field],
               let yJSONValue = datum[y.field] {
                // Possible case:
                //  Int, Int; Int, Double; Int, Date;
                //  Double, Int; Double, Double; Double, Date;
                //  Date, Int; Date, Double; Date, Date;
                //  String, Int; String, Double; String, Date;
                if let xIntValue = x.plottableInt(xJSONValue) {
                    if let yIntValue = y.plottableInt(yJSONValue) {
                        applyCommonConfig(pointMark(x: xIntValue, y: yIntValue), commonConfig: commonConfig, datum: datum)
                    } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                        applyCommonConfig(pointMark(x: xIntValue, y: yDoubleValue), commonConfig: commonConfig, datum: datum)
                    } else if let yDateValue = y.plottableDate(yJSONValue) {
                        applyCommonConfig(pointMark(x: xIntValue, y: yDateValue), commonConfig: commonConfig, datum: datum)
                    }
                } else if let xDoubleValue = x.plottableDouble(xJSONValue) {
                    if let yIntValue = y.plottableInt(yJSONValue) {
                        applyCommonConfig(pointMark(x: xDoubleValue, y: yIntValue), commonConfig: commonConfig, datum: datum)
                    } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                        applyCommonConfig(pointMark(x: xDoubleValue, y: yDoubleValue), commonConfig: commonConfig, datum: datum)
                    } else if let yDateValue = y.plottableDate(yJSONValue) {
                        applyCommonConfig(pointMark(x: xDoubleValue, y: yDateValue), commonConfig: commonConfig, datum: datum)
                    }
                } else if let xDateValue = x.plottableDate(xJSONValue) {
                    if let yIntValue = y.plottableInt(yJSONValue) {
                        applyCommonConfig(pointMark(x: xDateValue, y: yIntValue), commonConfig: commonConfig, datum: datum)
                    } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                        applyCommonConfig(pointMark(x: xDateValue, y: yDoubleValue), commonConfig: commonConfig, datum: datum)
                    } else if let yDateValue = y.plottableDate(yJSONValue) {
                        applyCommonConfig(pointMark(x: xDateValue, y: yDateValue), commonConfig: commonConfig, datum: datum)
                    }
                } else if let xStringValue = x.plottableString(xJSONValue) {
                    if let yIntValue = y.plottableInt(yJSONValue) {
                        applyCommonConfig(pointMark(x: xStringValue, y: yIntValue), commonConfig: commonConfig, datum: datum)
                    } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                        applyCommonConfig(pointMark(x: xStringValue, y: yDoubleValue), commonConfig: commonConfig, datum: datum)
                    } else if let yDateValue = y.plottableDate(yJSONValue) {
                        applyCommonConfig(pointMark(x: xStringValue, y: yDateValue), commonConfig: commonConfig, datum: datum)
                    }
                }
            }
        }
    }

    @ChartContentBuilder
    func toChartContent(configuration: ChartConfiguration, commonConfig: ChartComponentCommonConfig) -> some ChartContent {
        if let dataItem: ChartDataItem = configuration.chartData.dataItems[dataKey] {
            switch self {
            case let .barMarkRepeat1(_, xStart, xEnd, y, height):
                barMarkRepeat1(configuration: configuration, commonConfig: commonConfig, dataItem: dataItem, xStart: xStart, xEnd: xEnd, y: y, height: height)
            case let .lineMarkRepeat1(_, x, y):
                lineMarkRepeat1(configuration: configuration, commonConfig: commonConfig, dataItem: dataItem, x: x, y: y)
            case let .rectangleMarkRepeat1(_, xStart, xEnd, yStart, yEnd):
                rectangleMarkRepeat1(configuration: configuration, commonConfig: commonConfig, dataItem: dataItem, xStart: xStart, xEnd: xEnd, yStart: yStart, yEnd: yEnd)
            case let .ruleMarkRepeat1(_, x, yStart, yEnd):
                ruleMarkRepeat1(configuration: configuration, commonConfig: commonConfig, dataItem: dataItem, x: x, yStart: yStart, yEnd: yEnd)
            case let .pointMarkRepeat1(_, x, y):
                pointMarkRepeat1(configuration: configuration, commonConfig: commonConfig, dataItem: dataItem, x: x, y: y)
            }
        }
    }
}

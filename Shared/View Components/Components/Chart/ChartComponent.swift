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
    func toChartContent(configuration: ChartConfiguration) -> some ChartContent {
        switch self {
        case let .barMarkRepeat1(dataKey, xStart, xEnd, y, height):
            if let dataItem = configuration.chartData.dataItems[dataKey] {
                ForEach(0 ..< dataItem.length, id: \.self) { index in
                    if let xStartJSONValue = dataItem.data[xStart.field].array?[safe: index],
                       let xEndJSONValue = dataItem.data[xEnd.field].array?[safe: index],
                       let yJSONValue = dataItem.data[y.field].array?[safe: index] {
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
            }
        case let .lineMarkRepeat1(dataKey, x, y):
            if let dataItem = configuration.chartData.dataItems[dataKey] {
                ForEach(0 ..< dataItem.length, id: \.self) { index in
                    if let xJSONValue = dataItem.data[x.field].array?[safe: index],
                       let yJSONValue = dataItem.data[y.field].array?[safe: index] {
                        // Possible case:
                        //  Int, Int; Int, Double; Int, Date;
                        //  Double, Int; Double, Double; Double, Date;
                        //  Date, Int; Date, Double; Date, Date;
                        //  String, Int; String, Double; String, Date;
                        if let xIntValue = x.plottableInt(xJSONValue) {
                            if let yIntValue = y.plottableInt(yJSONValue) {
                                lineMark(x: xIntValue, y: yIntValue)
                            } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                                lineMark(x: xIntValue, y: yDoubleValue)
                            } else if let yDateValue = y.plottableDate(yJSONValue) {
                                lineMark(x: xIntValue, y: yDateValue)
                            }
                        } else if let xDoubleValue = x.plottableDouble(xJSONValue) {
                            if let yIntValue = y.plottableInt(yJSONValue) {
                                lineMark(x: xDoubleValue, y: yIntValue)
                            } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                                lineMark(x: xDoubleValue, y: yDoubleValue)
                            } else if let yDateValue = y.plottableDate(yJSONValue) {
                                lineMark(x: xDoubleValue, y: yDateValue)
                            }
                        } else if let xDateValue = x.plottableDate(xJSONValue) {
                            if let yIntValue = y.plottableInt(yJSONValue) {
                                lineMark(x: xDateValue, y: yIntValue)
                            } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                                lineMark(x: xDateValue, y: yDoubleValue)
                            } else if let yDateValue = y.plottableDate(yJSONValue) {
                                lineMark(x: xDateValue, y: yDateValue)
                            }
                        } else if let xStringValue = x.plottableString(xJSONValue) {
                            if let yIntValue = y.plottableInt(yJSONValue) {
                                lineMark(x: xStringValue, y: yIntValue)
                            } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                                lineMark(x: xStringValue, y: yDoubleValue)
                            } else if let yDateValue = y.plottableDate(yJSONValue) {
                                lineMark(x: xStringValue, y: yDateValue)
                            }
                        }
                    }
                }
            }
        case let .rectangleMarkRepeat1(dataKey, xStart, xEnd, yStart, yEnd):
            if let dataItem = configuration.chartData.dataItems[dataKey] {
                ForEach(0 ..< dataItem.length, id: \.self) { index in
                    if let xStartJSONValue = dataItem.data[xStart.field].array?[safe: index],
                       let xEndJSONValue = dataItem.data[xEnd.field].array?[safe: index],
                       let yStartJSONValue = dataItem.data[yStart.field].array?[safe: index],
                       let yEndJSONValue = dataItem.data[yEnd.field].array?[safe: index] {
                        // Possible case:
                        // Int, Int; Int, Double; Int, Date;
                        // Double, Int; Double, Double; Double, Date;
                        //  Date, Int; Date, Double; Date, Date;
                        if let xStartIntValue = xStart.plottableInt(xStartJSONValue), let xEndIntValue = xEnd.plottableInt(xEndJSONValue) {
                            if let yStartIntValue = yStart.plottableInt(yStartJSONValue), let yEndIntValue = yEnd.plottableInt(yEndJSONValue) {
                                rectangleMark(xStart: xStartIntValue, xEnd: xEndIntValue, yStart: yStartIntValue, yEnd: yEndIntValue)
                            } else if let yStartDoubleValue = yStart.plottableDouble(yStartJSONValue), let yEndDoubleValue = yEnd.plottableDouble(yEndJSONValue) {
                                rectangleMark(xStart: xStartIntValue, xEnd: xEndIntValue, yStart: yStartDoubleValue, yEnd: yEndDoubleValue)
                            } else if let yStartDateValue = yStart.plottableDate(yStartJSONValue), let yEndDateValue = yEnd.plottableDate(yEndJSONValue) {
                                rectangleMark(xStart: xStartIntValue, xEnd: xEndIntValue, yStart: yStartDateValue, yEnd: yEndDateValue)
                            }
                        } else if let xStartDoubleValue = xStart.plottableDouble(xStartJSONValue), let xEndDoubleValue = xEnd.plottableDouble(xEndJSONValue) {
                            if let yStartIntValue = yStart.plottableInt(yStartJSONValue), let yEndIntValue = yEnd.plottableInt(yEndJSONValue) {
                                rectangleMark(xStart: xStartDoubleValue, xEnd: xEndDoubleValue, yStart: yStartIntValue, yEnd: yEndIntValue)
                            } else if let yStartDoubleValue = yStart.plottableDouble(yStartJSONValue), let yEndDoubleValue = yEnd.plottableDouble(yEndJSONValue) {
                                rectangleMark(xStart: xStartDoubleValue, xEnd: xEndDoubleValue, yStart: yStartDoubleValue, yEnd: yEndDoubleValue)
                            } else if let yStartDateValue = yStart.plottableDate(yStartJSONValue), let yEndDateValue = yEnd.plottableDate(yEndJSONValue) {
                                rectangleMark(xStart: xStartDoubleValue, xEnd: xEndDoubleValue, yStart: yStartDateValue, yEnd: yEndDateValue)
                            }
                        } else if let xStartDateValue = xStart.plottableDate(xStartJSONValue), let xEndDateValue = xEnd.plottableDate(xEndJSONValue) {
                            if let yStartIntValue = yStart.plottableInt(yStartJSONValue), let yEndIntValue = yEnd.plottableInt(yEndJSONValue) {
                                rectangleMark(xStart: xStartDateValue, xEnd: xEndDateValue, yStart: yStartIntValue, yEnd: yEndIntValue)
                            } else if let yStartDoubleValue = yStart.plottableDouble(yStartJSONValue), let yEndDoubleValue = yEnd.plottableDouble(yEndJSONValue) {
                                rectangleMark(xStart: xStartDateValue, xEnd: xEndDateValue, yStart: yStartDoubleValue, yEnd: yEndDoubleValue)
                            } else if let yStartDateValue = yStart.plottableDate(yStartJSONValue), let yEndDateValue = yEnd.plottableDate(yEndJSONValue) {
                                rectangleMark(xStart: xStartDateValue, xEnd: xEndDateValue, yStart: yStartDateValue, yEnd: yEndDateValue)
                            }
                        }
                    }
                }
            }
        case let .ruleMarkRepeat1(dataKey, x, yStart, yEnd):
            if let dataItem = configuration.chartData.dataItems[dataKey] {
                ForEach(0 ..< dataItem.length, id: \.self) { index in
                    if let xJSONValue = dataItem.data[x.field].array?[safe: index] {
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
                                      let yStartJSONValue = dataItem.data[yStart.field].array?[safe: index],
                                      let yEndJSONValue = dataItem.data[yEnd.field].array?[safe: index]
                            {
                                if let yStartIntValue = yStart.plottableInt(yStartJSONValue), let yEndIntValue = yEnd.plottableInt(yEndJSONValue) {
                                    ruleMark(x: xIntValue, yStart: yStartIntValue, yEnd: yEndIntValue)
                                } else if let yStartDoubleValue = yStart.plottableDouble(yStartJSONValue), let yEndDoubleValue = yEnd.plottableDouble(yEndJSONValue) {
                                    ruleMark(x: xIntValue, yStart: yStartDoubleValue, yEnd: yEndDoubleValue)
                                } else if let yStartDateValue = yStart.plottableDate(yStartJSONValue), let yEndDateValue = yEnd.plottableDate(yEndJSONValue) {
                                    ruleMark(x: xIntValue, yStart: yStartDateValue, yEnd: yEndDateValue)
                                }
                            }
                        } else if let xDoubleValue = x.plottableDouble(xJSONValue) {
                            if yStart == nil || yEnd == nil {
                                ruleMark(x: xDoubleValue)
                            } else if let yStart = yStart,
                                      let yEnd = yEnd,
                                      let yStartJSONValue = dataItem.data[yStart.field].array?[safe: index],
                                      let yEndJSONValue = dataItem.data[yEnd.field].array?[safe: index]
                            {
                                if let yStartIntValue = yStart.plottableInt(yStartJSONValue), let yEndIntValue = yEnd.plottableInt(yEndJSONValue) {
                                    ruleMark(x: xDoubleValue, yStart: yStartIntValue, yEnd: yEndIntValue)
                                } else if let yStartDoubleValue = yStart.plottableDouble(yStartJSONValue), let yEndDoubleValue = yEnd.plottableDouble(yEndJSONValue) {
                                    ruleMark(x: xDoubleValue, yStart: yStartDoubleValue, yEnd: yEndDoubleValue)
                                } else if let yStartDateValue = yStart.plottableDate(yStartJSONValue), let yEndDateValue = yEnd.plottableDate(yEndJSONValue) {
                                    ruleMark(x: xDoubleValue, yStart: yStartDateValue, yEnd: yEndDateValue)
                                }
                            }
                        } else if let xDateValue = x.plottableDate(xJSONValue) {
                            if yStart == nil || yEnd == nil {
                                ruleMark(x: xDateValue)
                            } else if let yStart = yStart,
                                      let yEnd = yEnd,
                                      let yStartJSONValue = dataItem.data[yStart.field].array?[safe: index],
                                      let yEndJSONValue = dataItem.data[yEnd.field].array?[safe: index]
                            {
                                if let yStartIntValue = yStart.plottableInt(yStartJSONValue), let yEndIntValue = yEnd.plottableInt(yEndJSONValue) {
                                    ruleMark(x: xDateValue, yStart: yStartIntValue, yEnd: yEndIntValue)
                                } else if let yStartDoubleValue = yStart.plottableDouble(yStartJSONValue), let yEndDoubleValue = yEnd.plottableDouble(yEndJSONValue) {
                                    ruleMark(x: xDateValue, yStart: yStartDoubleValue, yEnd: yEndDoubleValue)
                                } else if let yStartDateValue = yStart.plottableDate(yStartJSONValue), let yEndDateValue = yEnd.plottableDate(yEndJSONValue) {
                                    ruleMark(x: xDateValue, yStart: yStartDateValue, yEnd: yEndDateValue)
                                }
                            }
                        } else if let xStringValue = x.plottableString(xJSONValue) {
                            if yStart == nil || yEnd == nil {
                                ruleMark(x: xStringValue)
                            } else if let yStart = yStart,
                                      let yEnd = yEnd,
                                      let yStartJSONValue = dataItem.data[yStart.field].array?[safe: index],
                                      let yEndJSONValue = dataItem.data[yEnd.field].array?[safe: index]
                            {
                                if let yStartIntValue = yStart.plottableInt(yStartJSONValue), let yEndIntValue = yEnd.plottableInt(yEndJSONValue) {
                                    ruleMark(x: xStringValue, yStart: yStartIntValue, yEnd: yEndIntValue)
                                } else if let yStartDoubleValue = yStart.plottableDouble(yStartJSONValue), let yEndDoubleValue = yEnd.plottableDouble(yEndJSONValue) {
                                    ruleMark(x: xStringValue, yStart: yStartDoubleValue, yEnd: yEndDoubleValue)
                                } else if let yStartDateValue = yStart.plottableDate(yStartJSONValue), let yEndDateValue = yEnd.plottableDate(yEndJSONValue) {
                                    ruleMark(x: xStringValue, yStart: yStartDateValue, yEnd: yEndDateValue)
                                }
                            }
                        }
                    }
                }
            }
        case let .pointMarkRepeat1(dataKey, x, y):
            if let dataItem = configuration.chartData.dataItems[dataKey] {
                ForEach(0 ..< dataItem.length, id: \.self) { index in
                    if let xJSONValue = dataItem.data[x.field].array?[safe: index],
                       let yJSONValue = dataItem.data[y.field].array?[safe: index] {
                        // Possible case:
                        //  Int, Int; Int, Double; Int, Date;
                        //  Double, Int; Double, Double; Double, Date;
                        //  Date, Int; Date, Double; Date, Date;
                        //  String, Int; String, Double; String, Date;
                        if let xIntValue = x.plottableInt(xJSONValue) {
                            if let yIntValue = y.plottableInt(yJSONValue) {
                                pointMark(x: xIntValue, y: yIntValue)
                            } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                                pointMark(x: xIntValue, y: yDoubleValue)
                            } else if let yDateValue = y.plottableDate(yJSONValue) {
                                pointMark(x: xIntValue, y: yDateValue)
                            }
                        } else if let xDoubleValue = x.plottableDouble(xJSONValue) {
                            if let yIntValue = y.plottableInt(yJSONValue) {
                                pointMark(x: xDoubleValue, y: yIntValue)
                            } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                                pointMark(x: xDoubleValue, y: yDoubleValue)
                            } else if let yDateValue = y.plottableDate(yJSONValue) {
                                pointMark(x: xDoubleValue, y: yDateValue)
                            }
                        } else if let xDateValue = x.plottableDate(xJSONValue) {
                            if let yIntValue = y.plottableInt(yJSONValue) {
                                pointMark(x: xDateValue, y: yIntValue)
                            } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                                pointMark(x: xDateValue, y: yDoubleValue)
                            } else if let yDateValue = y.plottableDate(yJSONValue) {
                                pointMark(x: xDateValue, y: yDateValue)
                            }
                        } else if let xStringValue = x.plottableString(xJSONValue) {
                            if let yIntValue = y.plottableInt(yJSONValue) {
                                pointMark(x: xStringValue, y: yIntValue)
                            } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                                pointMark(x: xStringValue, y: yDoubleValue)
                            } else if let yDateValue = y.plottableDate(yJSONValue) {
                                pointMark(x: xStringValue, y: yDateValue)
                            }
                        }
                    }
                }
            }
        }
    }
}

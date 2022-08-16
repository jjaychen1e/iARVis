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
}

enum ChartComponentType: String, RawRepresentable {
    case barMark = "BarMark"
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
        }
    }
}

extension ChartComponent {
    private func barkMark<X: Plottable, Y: Plottable>(configuration: ChartConfiguration, dataElement: JSON, xStart: PlottableValue<X>, xEnd: PlottableValue<X>, y: PlottableValue<Y>, height: CGFloat?) -> some ChartContent {
        BarMark(xStart: xStart, xEnd: xEnd, y: y, height: height != nil ? .fixed(height!) : .automatic)
//            .annotation {
//                if let selectedElement = configuration.interactionData.componentSelectedElementInRangeX[self],
//                   dataElement == selectedElement,
//                   let viewComponent = configuration.interactionData.componentSelectedElementView[self] {
//                    ChartTooltipView(viewComponent)
//                }
//            }
    }

    @ChartContentBuilder
    func toChartContent(configuration: ChartConfiguration) -> some ChartContent {
        switch self {
        case let .barMarkRepeat1(xStart, xEnd, y, height):
            ForEach(0 ..< configuration.chartData.length, id: \.self) { index in
                let currentDataElement: JSON = {
                    var dict: [String: JSON] = [:]
                    for title in configuration.chartData.titles {
                        dict[title] = configuration.chartData.data[title].array?[safe: index]
                    }
                    return JSON(dict)
                }()

                if let xStartJSONValue = configuration.chartData.data[xStart.field].array?[safe: index],
                   let xEndJSONValue = configuration.chartData.data[xEnd.field].array?[safe: index],
                   let yJSONValue = configuration.chartData.data[y.field].array?[safe: index] {
                    // Possible case:
                    // Int, String; Int, Int; Int, Double; Int, Date;
                    // Double, String; Double, Int; Double, Double; Double, Date;
                    // Date, String; Date, Int; Date, Double; Date, Date;
                    if let xStartIntValue = xStart.plottableInt(xStartJSONValue), let xEndIntValue = xEnd.plottableInt(xEndJSONValue) {
                        if let yIntValue = y.plottableInt(yJSONValue) {
                            barkMark(configuration: configuration, dataElement: currentDataElement, xStart: xStartIntValue, xEnd: xEndIntValue, y: yIntValue, height: height)
                        } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                            barkMark(configuration: configuration, dataElement: currentDataElement, xStart: xStartIntValue, xEnd: xEndIntValue, y: yDoubleValue, height: height)
                        } else if let yDateValue = y.plottableDate(yJSONValue) {
                            barkMark(configuration: configuration, dataElement: currentDataElement, xStart: xStartIntValue, xEnd: xEndIntValue, y: yDateValue, height: height)
                        } else if let yStringValue = y.plottableString(yJSONValue) {
                            barkMark(configuration: configuration, dataElement: currentDataElement, xStart: xStartIntValue, xEnd: xEndIntValue, y: yStringValue, height: height)
                        }
                    } else if let xStartDoubleValue = xStart.plottableDouble(xStartJSONValue), let xEndDoubleValue = xEnd.plottableDouble(xEndJSONValue) {
                        if let yIntValue = y.plottableInt(yJSONValue) {
                            barkMark(configuration: configuration, dataElement: currentDataElement, xStart: xStartDoubleValue, xEnd: xEndDoubleValue, y: yIntValue, height: height)
                        } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                            barkMark(configuration: configuration, dataElement: currentDataElement, xStart: xStartDoubleValue, xEnd: xEndDoubleValue, y: yDoubleValue, height: height)
                        } else if let yDateValue = y.plottableDate(yJSONValue) {
                            barkMark(configuration: configuration, dataElement: currentDataElement, xStart: xStartDoubleValue, xEnd: xEndDoubleValue, y: yDateValue, height: height)
                        } else if let yStringValue = y.plottableString(yJSONValue) {
                            barkMark(configuration: configuration, dataElement: currentDataElement, xStart: xStartDoubleValue, xEnd: xEndDoubleValue, y: yStringValue, height: height)
                        }
                    } else if let xStartDateValue = xStart.plottableDate(xStartJSONValue), let xEndDateValue = xEnd.plottableDate(xEndJSONValue) {
                        if let yIntValue = y.plottableInt(yJSONValue) {
                            barkMark(configuration: configuration, dataElement: currentDataElement, xStart: xStartDateValue, xEnd: xEndDateValue, y: yIntValue, height: height)
                        } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                            barkMark(configuration: configuration, dataElement: currentDataElement, xStart: xStartDateValue, xEnd: xEndDateValue, y: yDoubleValue, height: height)
                        } else if let yDateValue = y.plottableDate(yJSONValue) {
                            barkMark(configuration: configuration, dataElement: currentDataElement, xStart: xStartDateValue, xEnd: xEndDateValue, y: yDateValue, height: height)
                        } else if let yStringValue = y.plottableString(yJSONValue) {
                            barkMark(configuration: configuration, dataElement: currentDataElement, xStart: xStartDateValue, xEnd: xEndDateValue, y: yStringValue, height: height)
                        }
                    }
                }
            }
        }
    }
}

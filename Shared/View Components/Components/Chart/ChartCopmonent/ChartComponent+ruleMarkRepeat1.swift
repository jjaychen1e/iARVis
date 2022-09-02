//
//  ChartComponent+ruleMarkRepeat1.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/9/2.
//

import Charts
import Foundation
import SwiftUI
import SwiftyJSON

@available(iOS 16, *)
extension ChartComponent {
    @ChartContentBuilder
    func ruleMarkRepeat1(configuration _: ChartConfiguration, commonConfig: ChartComponentCommonConfig, dataItem: ChartDataItem, x: ARVisPlottableValueFieldPair, yStart: ARVisPlottableValueFieldPair?, yEnd: ARVisPlottableValueFieldPair?) -> some ChartContent {
        let datumArray = dataItem.datumArray()
        ForEach(0 ..< dataItem.length, id: \.self) { index in
            let datum = datumArray[index]
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
                            applyCommonConfig(ruleMark(x: xIntValue, yStart: yStartIntValue, yEnd: yEndIntValue), commonConfig: commonConfig, datumDictionary: datum)
                        } else if let yStartDoubleValue = yStart.plottableDouble(yStartJSONValue), let yEndDoubleValue = yEnd.plottableDouble(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xIntValue, yStart: yStartDoubleValue, yEnd: yEndDoubleValue), commonConfig: commonConfig, datumDictionary: datum)
                        } else if let yStartDateValue = yStart.plottableDate(yStartJSONValue), let yEndDateValue = yEnd.plottableDate(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xIntValue, yStart: yStartDateValue, yEnd: yEndDateValue), commonConfig: commonConfig, datumDictionary: datum)
                        }
                    }
                } else if let xDoubleValue = x.plottableDouble(xJSONValue) {
                    if yStart == nil || yEnd == nil {
                        applyCommonConfig(ruleMark(x: xDoubleValue), commonConfig: commonConfig, datumDictionary: datum)
                    } else if let yStart = yStart,
                              let yEnd = yEnd,
                              let yStartJSONValue = datum[yStart.field],
                              let yEndJSONValue = datum[yEnd.field] {
                        if let yStartIntValue = yStart.plottableInt(yStartJSONValue), let yEndIntValue = yEnd.plottableInt(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xDoubleValue, yStart: yStartIntValue, yEnd: yEndIntValue), commonConfig: commonConfig, datumDictionary: datum)
                        } else if let yStartDoubleValue = yStart.plottableDouble(yStartJSONValue), let yEndDoubleValue = yEnd.plottableDouble(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xDoubleValue, yStart: yStartDoubleValue, yEnd: yEndDoubleValue), commonConfig: commonConfig, datumDictionary: datum)
                        } else if let yStartDateValue = yStart.plottableDate(yStartJSONValue), let yEndDateValue = yEnd.plottableDate(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xDoubleValue, yStart: yStartDateValue, yEnd: yEndDateValue), commonConfig: commonConfig, datumDictionary: datum)
                        }
                    }
                } else if let xDateValue = x.plottableDate(xJSONValue) {
                    if yStart == nil || yEnd == nil {
                        applyCommonConfig(ruleMark(x: xDateValue), commonConfig: commonConfig, datumDictionary: datum)
                    } else if let yStart = yStart,
                              let yEnd = yEnd,
                              let yStartJSONValue = datum[yStart.field],
                              let yEndJSONValue = datum[yEnd.field] {
                        if let yStartIntValue = yStart.plottableInt(yStartJSONValue), let yEndIntValue = yEnd.plottableInt(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xDateValue, yStart: yStartIntValue, yEnd: yEndIntValue), commonConfig: commonConfig, datumDictionary: datum)
                        } else if let yStartDoubleValue = yStart.plottableDouble(yStartJSONValue), let yEndDoubleValue = yEnd.plottableDouble(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xDateValue, yStart: yStartDoubleValue, yEnd: yEndDoubleValue), commonConfig: commonConfig, datumDictionary: datum)
                        } else if let yStartDateValue = yStart.plottableDate(yStartJSONValue), let yEndDateValue = yEnd.plottableDate(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xDateValue, yStart: yStartDateValue, yEnd: yEndDateValue), commonConfig: commonConfig, datumDictionary: datum)
                        }
                    }
                } else if let xStringValue = x.plottableString(xJSONValue) {
                    if yStart == nil || yEnd == nil {
                        applyCommonConfig(ruleMark(x: xStringValue), commonConfig: commonConfig, datumDictionary: datum)
                    } else if let yStart = yStart,
                              let yEnd = yEnd,
                              let yStartJSONValue = datum[yStart.field],
                              let yEndJSONValue = datum[yEnd.field] {
                        if let yStartIntValue = yStart.plottableInt(yStartJSONValue), let yEndIntValue = yEnd.plottableInt(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xStringValue, yStart: yStartIntValue, yEnd: yEndIntValue), commonConfig: commonConfig, datumDictionary: datum)
                        } else if let yStartDoubleValue = yStart.plottableDouble(yStartJSONValue), let yEndDoubleValue = yEnd.plottableDouble(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xStringValue, yStart: yStartDoubleValue, yEnd: yEndDoubleValue), commonConfig: commonConfig, datumDictionary: datum)
                        } else if let yStartDateValue = yStart.plottableDate(yStartJSONValue), let yEndDateValue = yEnd.plottableDate(yEndJSONValue) {
                            applyCommonConfig(ruleMark(x: xStringValue, yStart: yStartDateValue, yEnd: yEndDateValue), commonConfig: commonConfig, datumDictionary: datum)
                        }
                    }
                }
            }
        }
    }
}

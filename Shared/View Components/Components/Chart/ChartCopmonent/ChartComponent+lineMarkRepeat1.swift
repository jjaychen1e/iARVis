//
//  ChartComponent+lineMarkRepeat1.swift
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
    func lineMarkRepeat1(configuration _: ChartConfiguration, commonConfig: ChartComponentCommonConfig, dataItem: ChartDataItem, x: ARVisPlottableValueFieldPair, y: ARVisPlottableValueFieldPair) -> some ChartContent {
        let datumArray = dataItem.datumArray()
        ForEach(0 ..< dataItem.length, id: \.self) { index in
            let datum = datumArray[index]
            if let xJSONValue = datum[x.field],
               let yJSONValue = datum[y.field] {
                // Possible case:
                //  Int, Int; Int, Double; Int, Date;
                //  Double, Int; Double, Double; Double, Date;
                //  Date, Int; Date, Double; Date, Date;
                //  String, Int; String, Double; String, Date;
                if let xIntValue = x.plottableInt(xJSONValue) {
                    if let yIntValue = y.plottableInt(yJSONValue) {
                        applyCommonConfig(lineMark(x: xIntValue, y: yIntValue), commonConfig: commonConfig, datumDictionary: datum)
                    } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                        applyCommonConfig(lineMark(x: xIntValue, y: yDoubleValue), commonConfig: commonConfig, datumDictionary: datum)
                    } else if let yDateValue = y.plottableDate(yJSONValue) {
                        applyCommonConfig(lineMark(x: xIntValue, y: yDateValue), commonConfig: commonConfig, datumDictionary: datum)
                    }
                } else if let xDoubleValue = x.plottableDouble(xJSONValue) {
                    if let yIntValue = y.plottableInt(yJSONValue) {
                        applyCommonConfig(lineMark(x: xDoubleValue, y: yIntValue), commonConfig: commonConfig, datumDictionary: datum)
                    } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                        applyCommonConfig(lineMark(x: xDoubleValue, y: yDoubleValue), commonConfig: commonConfig, datumDictionary: datum)
                    } else if let yDateValue = y.plottableDate(yJSONValue) {
                        applyCommonConfig(lineMark(x: xDoubleValue, y: yDateValue), commonConfig: commonConfig, datumDictionary: datum)
                    }
                } else if let xDateValue = x.plottableDate(xJSONValue) {
                    if let yIntValue = y.plottableInt(yJSONValue) {
                        applyCommonConfig(lineMark(x: xDateValue, y: yIntValue), commonConfig: commonConfig, datumDictionary: datum)
                    } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                        applyCommonConfig(lineMark(x: xDateValue, y: yDoubleValue), commonConfig: commonConfig, datumDictionary: datum)
                    } else if let yDateValue = y.plottableDate(yJSONValue) {
                        applyCommonConfig(lineMark(x: xDateValue, y: yDateValue), commonConfig: commonConfig, datumDictionary: datum)
                    }
                } else if let xStringValue = x.plottableString(xJSONValue) {
                    if let yIntValue = y.plottableInt(yJSONValue) {
                        applyCommonConfig(lineMark(x: xStringValue, y: yIntValue), commonConfig: commonConfig, datumDictionary: datum)
                    } else if let yDoubleValue = y.plottableDouble(yJSONValue) {
                        applyCommonConfig(lineMark(x: xStringValue, y: yDoubleValue), commonConfig: commonConfig, datumDictionary: datum)
                    } else if let yDateValue = y.plottableDate(yJSONValue) {
                        applyCommonConfig(lineMark(x: xStringValue, y: yDateValue), commonConfig: commonConfig, datumDictionary: datum)
                    }
                }
            }
        }
    }
}

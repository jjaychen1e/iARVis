//
//  Tests_macOSChartConfigurationJSONParser.swift
//  Tests macOS
//
//  Created by Junjie Chen on 2022/8/14.
//

import XCTest
import SwiftyJSON
import iARVis

final class Tests_macOSChartConfigurationJSONParser: XCTestCase {
    func testParseExample1() {
        let res = ChartConfigurationJSONParser.default.parse(JSON(ChartConfigurationJSONParser.exampleJSONString1.data(using: .utf8)!))
        print(res)
    }
}

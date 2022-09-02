//
//  SwiftChartConfiguration.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/31.
//

import Foundation

struct SwiftChartConfiguration: Codable, Equatable {
    var chartXScale: ChartXScale?
    var chartYScale: ChartYScale?
    var chartXAxis: ChartXAxis?
    var chartYAxis: ChartYAxis?
    var styleConfiguration: ChartStyleConfiguration?
    var chartLegend: ChartLegend?
}

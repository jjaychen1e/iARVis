//
//  ChartConfiguration.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/14.
//

import Charts
import Foundation
import SwiftUI
import SwiftyJSON

struct ChartConfiguration: Equatable{
    var chartData = ChartData()
    var componentConfigs: [ChartComponentConfiguration] = []
    var interactionData = ChartInteractionData()
    var chartXScale: ChartXScale?
    var chartXAxis: ChartXAxis?
    var chartYAxis: ChartYAxis?
    var styleConfiguration: ChartStyleConfiguration?
}

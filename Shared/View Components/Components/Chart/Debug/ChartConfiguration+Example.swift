//
//  ChartConfiguration+Example.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/14.
//

import Foundation

extension ChartConfiguration {
    static let example1 = ChartConfiguration(
        chartData: ChartData(
            data: [
                "Name": ["James Ensor", "Alexandra Daveluy", "Casino Communal", "Louis Franck", "Foudation Socindec", "Getty Museum"],
                "Start": ["1888-01-01", "1949-01-01", "1950-01-01", "1954-01-01", "1969-01-01", "1987-01-01"],
                "End": ["1949-01-01", "1950-01-01", "1954-01-01", "1969-01-01", "1987-01-01", "2022-01-01"],
            ]
        ),
        components: [
            .barMarkRepeat1(xStart: .value("Start"), xEnd: .value("End"), y: .value("Name"), height: 15),
        ],
        chartXScale: ChartXScale(domain: ["1888-01-01", "2022-01-01"]),
        styleConfiguration: ChartStyleConfiguration(maxHeight: 250)
    )
}

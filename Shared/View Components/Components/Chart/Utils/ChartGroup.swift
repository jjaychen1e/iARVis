//
//  ChartGroup.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/9/2.
//

import Foundation
import Charts

@available(iOS 16, *)
struct ChartGroup<Content: ChartContent>: ChartContent {
    @ChartContentBuilder
    let content: () -> Content

    var body: some ChartContent {
        content()
    }
}

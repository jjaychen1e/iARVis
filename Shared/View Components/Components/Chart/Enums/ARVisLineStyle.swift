//
//  ARVisLineStyle.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/26.
//

import Foundation
import SwiftUI

struct ARVisLineStyle: Codable, Equatable {
    var lineWidth: CGFloat = 1
}

extension StrokeStyle {
    init(_ lineStyle: ARVisLineStyle) {
        self = .init(lineWidth: lineStyle.lineWidth)
    }
}

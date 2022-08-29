//
//  ARVisInterpolationMethod.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/23.
//

import Charts
import Foundation

enum ARVisInterpolationMethod: String, RawRepresentable, Codable {
    case linear
    case cardinal
}

@available(iOS 16, *)
extension InterpolationMethod {
    init(_ interpolationMethod: ARVisInterpolationMethod) {
        switch interpolationMethod {
        case .linear:
            self = .linear
        case .cardinal:
            self = .cardinal
        }
    }
}

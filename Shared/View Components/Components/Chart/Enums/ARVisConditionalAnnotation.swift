//
//  ARVisConditionalAnnotation.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/31.
//

import Foundation
import SwiftyJSON

@available(iOS 16, *)
struct ARVisConditionalAnnotation: Codable, Equatable {
    var field: String
    var value: JSON
    var annotation: ARVisAnnotation
}

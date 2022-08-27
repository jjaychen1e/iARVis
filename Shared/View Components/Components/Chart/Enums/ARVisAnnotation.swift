//
//  ARVisAnnotation.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/8/26.
//

import Charts
import Foundation

enum ARVisAnnotationPosition: String, RawRepresentable, Codable {
    case topLeading
    case topTrailing
    case bottomTrailing
    case bottomLeading
}

struct ARVisAnnotation: Codable, Equatable {
    var position: ARVisAnnotationPosition
    var content: ViewElementComponent
}

extension AnnotationPosition {
    init(_ annotationPosition: ARVisAnnotationPosition) {
        switch annotationPosition {
        case .topLeading:
            self = .topLeading
        case .topTrailing:
            self = .topTrailing
        case .bottomTrailing:
            self = .bottomTrailing
        case .bottomLeading:
            self = .bottomLeading
        }
    }
}
//
//  ImageTrackingConfiguration.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/7/31.
//

import Foundation
import SceneKit

class ImageTrackingConfiguration: Codable {
    var imageURL: URL
    var relationships: [WidgetImageRelationship] = []

    init(imageURL: URL, relationships: [WidgetImageRelationship] = []) {
        self.imageURL = imageURL
        self.relationships = relationships
    }
}

class WidgetImageRelationship: Codable, Hashable {
    static func == (lhs: WidgetImageRelationship, rhs: WidgetImageRelationship) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var id = UUID()
    var widgetConfiguration: WidgetConfiguration

    init(widgetConfiguration: WidgetConfiguration) {
        self.widgetConfiguration = widgetConfiguration
    }
}

enum WidgetAnchorPoint: String, Codable, Equatable, CaseIterable {
    case center
    case leading
    case trailing
    case top
    case bottom
    case auto
}

extension ImageTrackingConfiguration {
    static let example1 = ImageTrackingExample.exampleConfiguration1
    static let example2 = ImageTrackingExample.exampleConfiguration2
}

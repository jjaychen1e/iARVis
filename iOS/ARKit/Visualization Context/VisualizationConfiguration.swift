//
//  VisualizationConfiguration.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/7/31.
//

import ARKit
import Foundation

class VisualizationConfiguration: Codable {
    var imageTrackingConfigurations: [ImageTrackingConfiguration]

    init(imageTrackingConfigurations: [ImageTrackingConfiguration]) {
        self.imageTrackingConfigurations = imageTrackingConfigurations
    }
}

extension VisualizationConfiguration {
    func findImageConfiguration(url: String) -> ImageTrackingConfiguration? {
        imageTrackingConfigurations.first { conf in
            conf.imageURL.absoluteString == url
        }
    }

    func findImageConfiguration(url: URL) -> ImageTrackingConfiguration? {
        findImageConfiguration(url: url.absoluteString)
    }

    func findImageConfiguration(anchor: ARImageAnchor) -> ImageTrackingConfiguration? {
        findImageConfiguration(url: anchor.referenceImage.name ?? anchor.referenceImage.name ?? "")
    }
}

extension VisualizationConfiguration {
    static let example1 = VisualizationConfiguration(imageTrackingConfigurations: [.example1])

    static let example2 = VisualizationConfiguration(imageTrackingConfigurations: [.example2])
    
    static let example3 = VisualizationConfiguration(imageTrackingConfigurations: [.example3])
    
    static let example4 = VisualizationConfiguration(imageTrackingConfigurations: [.example4])
}

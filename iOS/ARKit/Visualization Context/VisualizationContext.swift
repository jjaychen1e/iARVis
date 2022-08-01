//
//  VisualizationContext.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/7/31.
//

import ARKit
import SceneKit

typealias VisualizationConfigurationProcessResult = (referenceImages: [ARReferenceImage], referenceObjects: [ARReferenceObject])

class VisualizationContext {
    var visConfiguration: VisualizationConfiguration?
    var visConfigurationProcessingTask: Task<Void, Never>?

    struct NodePair {
        var _node = SCNNode()
        var node = SCNNode()
    }

    var imageNodePairMap: [String: NodePair] = [:]

    func reset() {
        visConfiguration = nil

        imageNodePairMap = [:]

        visConfigurationProcessingTask?.cancel()
        visConfigurationProcessingTask = nil
    }

    enum VisualizationConfigurationProcessingError: String, Error {
        case cancelled
        case fetchFailure
    }

    func processVisualizationConfiguration(completionHandler: @escaping (VisualizationConfigurationProcessResult) -> Void) {
        visConfigurationProcessingTask?.cancel()
        visConfigurationProcessingTask = nil

        visConfigurationProcessingTask = Task {
            do {
                guard !Task.isCancelled else { throw VisualizationConfigurationProcessingError.cancelled }

                let fetchResults = try await withThrowingTaskGroup(of: (URL, UIImage).self, body: { group in
                    var dataArray = [(URL, UIImage)]()

                    guard let imageTrackingConfigurations = visConfiguration?.imageTrackingConfigurations else {
                        return dataArray
                    }

                    dataArray.reserveCapacity(imageTrackingConfigurations.count)

                    for imageTrackingConfiguration in imageTrackingConfigurations {
                        group.addTask {
                            let result = try await ImageDownloader.default.download(url: imageTrackingConfiguration.imageURL)
                            return (imageTrackingConfiguration.imageURL, result)
                        }
                    }

                    for try await res in group {
                        dataArray.append(res)
                    }

                    return dataArray
                })

                guard !Task.isCancelled else { throw VisualizationConfigurationProcessingError.cancelled }

                let referenceImages = fetchResults.map {
                    let referenceImage = ARReferenceImage($0.1.cgImage!, orientation: .up, physicalWidth: 0.2)
                    referenceImage.name = $0.0.absoluteString
                    return referenceImage
                }

                guard !Task.isCancelled else { throw VisualizationConfigurationProcessingError.cancelled }

                completionHandler((referenceImages, []))
            } catch {
                printDebug(level: .warning, error.localizedDescription)
            }
        }
    }
}

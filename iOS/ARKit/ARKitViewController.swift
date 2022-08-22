//
//  ARKitViewController.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/7/28.
//

import ARKit
import SnapKit
import SwiftUI
import UIKit

class ARKitViewController: UIViewController {
    var visContext = VisualizationContext()

    let trackingSwitch = UISwitch()
    let trackingLabel = UILabel()

    override func loadView() {
        view = ARSCNView()
    }

    var sceneView: ARSCNView {
        view as! ARSCNView
    }

    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        sceneView.session
    }

    // MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.session.delegate = self

        // Debug
        trackingLabel.text = "Tracking: "
        trackingSwitch.isOn = true
        view.addSubview(trackingLabel)
        view.addSubview(trackingSwitch)
        trackingLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        trackingSwitch.snp.makeConstraints { make in
            make.leading.equalTo(trackingLabel.snp.trailing)
            make.centerY.equalTo(trackingLabel)
        }

        setVisualizationConfiguration(.example2)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Prevent the screen from being dimmed to avoid interrupting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true
    }

    // MARK: - Session management

    private func generateConfiguration(trackedImages: [ARReferenceImage] = [], trackedObjects: [ARReferenceObject] = []) -> ARConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        // Image tracking
        let referenceImages = Set(trackedImages)
        configuration.detectionImages = referenceImages
        // Enable auto scale estimation. But, DO NOT change the image size during tracking!
        configuration.automaticImageScaleEstimationEnabled = true
        configuration.maximumNumberOfTrackedImages = referenceImages.count

        // Object tracking
        configuration.detectionObjects = Set(trackedObjects)
        return configuration
    }

    /// Creates a new AR configuration to run on the `session`.
    func resetTracking(trackedImages: [ARReferenceImage] = [], trackedObjects: [ARReferenceObject] = []) {
        let configuration = generateConfiguration(trackedImages: trackedImages, trackedObjects: trackedObjects)
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}

// MARK: - Visualization Configuration

extension ARKitViewController {
    func setVisualizationConfiguration(_ conf: VisualizationConfiguration) {
        visContext.reset()

        visContext.visConfiguration = conf
        visContext.processVisualizationConfiguration { [weak self] result in
            if let self = self {
                DispatchQueue.main.async {
                    self.resetTracking(trackedImages: result.referenceImages, trackedObjects: result.referenceObjects)
                }
            }
        }
    }
}


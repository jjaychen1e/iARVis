//
//  ARKitViewController.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/7/28.
//

import ARKit
import UIKit

class ARKitViewController: UIViewController {
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Prevent the screen from being dimmed to avoid interrupting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true

        // Start the AR experience
        resetTracking()
    }

    // MARK: - Session management
    
    /// Creates a new AR configuration to run on the `session`.
    func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}

// MARK: - ARSCNViewDelegate
extension ARKitViewController: ARSCNViewDelegate {
    func renderer(_: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {}

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {}
}

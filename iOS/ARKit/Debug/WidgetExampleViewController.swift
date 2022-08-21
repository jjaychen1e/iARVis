//
//  WidgetExampleViewController.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/8/1.
//

import ARKit
import Foundation
import SnapKit
import SwiftUI
import SwiftyJSON
import UIKit

struct WidgetExampleView: View {
    @State var widgetConfiguration: WidgetConfiguration?
    var body: some View {
        ComponentView(widgetConfiguration?.components ?? [])
    }
}

struct WidgetExampleView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetExampleView()
    }
}

private class WidgetExampleContainerView: UIView {
    weak var viewController: WidgetExampleViewController?

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if let arKitVC = UIApplication.shared.topController() as? ARKitViewController {
            if let node = viewController?.node {
                let arSCNView = arKitVC.sceneView

                let (min, max) = node.boundingBox

                let bottomLeft = SCNVector3(min.x, min.y, 0)
                let topRight = SCNVector3(max.x, max.y, 0)
                let topLeft = SCNVector3(min.x, max.y, 0)

                let worldBottomLeft = node.convertPosition(bottomLeft, to: nil)
                let worldTopRight = node.convertPosition(topRight, to: nil)
                let worldTopLeft = node.convertPosition(topLeft, to: nil)

                let vecHorizontal = (worldTopRight - worldTopLeft).normalized
                let vecVertical = (worldBottomLeft - worldTopLeft).normalized

                if let plane = node.geometry as? SCNPlane {
                    let scale = plane.width / frame.width
                    let pointIn3D = worldTopLeft + scale * point.x * vecHorizontal + scale * point.y * vecVertical
                    let projected = arSCNView.projectPoint(pointIn3D)
                    let projectedPoint = CGPoint(x: CGFloat(projected.x), y: CGFloat(projected.y))

                    if let hitView = arSCNView.hitTest(projectedPoint, with: event) {
                        return hitView is ARSCNView
                    }
                }
            }

            return super.point(inside: point, with: event)
        }

        return false
    }
}

class WidgetExampleViewController: UIViewController {
    // TODO: Change the frame with plane's size using a fixed DPI.
    private let width: CGFloat = 720
    private let height: CGFloat = 540
    private var squareWidth: CGFloat {
        max(width, height)
    }

    weak var node: SCNNode?
    weak var widgetConfiguration: WidgetConfiguration?

    override func loadView() {
        view = {
            let view = WidgetExampleContainerView()
            view.viewController = self
            return view
        }()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        // Tap gesture's location will be messed up if view is not square-sized when using SwiftUI
        view.frame = CGRect(x: 0, y: 0, width: squareWidth, height: squareWidth)
        view.isOpaque = false
        view.backgroundColor = .clear

        let hostingViewController = UIHostingController(rootView: WidgetExampleView(widgetConfiguration: widgetConfiguration), ignoreSafeArea: true)
        hostingViewController.view.backgroundColor = .white
        addChildViewController(hostingViewController)
        hostingViewController.view.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
    }
}

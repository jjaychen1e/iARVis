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
    init(node: SCNWidgetNode) {
        self.node = node
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // TODO: Change the frame with plane's size using a fixed DPI.
    private var squareWidth: CGFloat {
        max(widgetConfiguration.size.width, widgetConfiguration.size.height)
    }

    var node: SCNWidgetNode
    var widgetConfiguration: WidgetConfiguration {
        node.widgetConfiguration
    }

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

        let widgetView = ComponentView(widgetConfiguration.component)
            .environment(\.openURL, OpenURLAction { [weak self] url in
                if let self = self {
                    let widgetConfiguration = self.widgetConfiguration
                    openURL(url, widgetConfiguration: widgetConfiguration)
                }
                return .handled
            })

        let hostingViewController = UIHostingController(rootView: widgetView, ignoreSafeArea: true)
        hostingViewController.view.backgroundColor = .white
        addChildViewController(hostingViewController)
        hostingViewController.view.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(widgetConfiguration.size)
        }
    }
}

@MainActor
func openURL(_ url: URL, widgetConfiguration: WidgetConfiguration? = nil) {
    let processWidget = { (widgetConfiguration: WidgetConfiguration, key: String, component: ViewElementComponent, anchor: WidgetAnchorPoint, position: SCNVector3) in
        let newWidgetConfiguration = WidgetConfiguration(
            component: component,
            relativeAnchorPoint: anchor,
            relativePosition: position
        )

        let isPresentationMode: Bool = {
            if let topController = UIApplication.shared.topController(),
               topController.presentingViewController != nil,
               topController is WidgetOnScreenViewController {
                return true
            }
            return false
        }()
        let isDisplayingInAR = widgetConfiguration.additionalWidgetConfiguration[key] != nil
        let isPresentingOnScreen = {
            if let topController = UIApplication.shared.topController(),
               topController.isBeingPresented,
               let topWidgetVC = topController as? WidgetOnScreenViewController,
               topWidgetVC.widgetConfiguration.component == component {
                return true
            }
            return false
        }()
        let canOpenInAR = !isPresentationMode && !isDisplayingInAR
        let canPresent: Bool = !isPresentingOnScreen && !isDisplayingInAR
        let openInAR = {
            widgetConfiguration.additionalWidgetConfiguration[key] = .init(key: key,
                                                                           widgetConfiguration: newWidgetConfiguration)
        }
        let presentOnScreen = {
            UIApplication.shared.presentOnTop(WidgetOnScreenViewController(widgetConfiguration: newWidgetConfiguration))
        }
        if canOpenInAR, canPresent {
            let alertController = UIAlertController(title: "Open", message: "Would you like to open the widget in AR, or display it on the screen?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Open in AR", style: .default, handler: { action in
                openInAR()
            }))
            alertController.addAction(UIAlertAction(title: "Display on screen", style: .default, handler: { action in
                presentOnScreen()
            }))
            UIApplication.shared.presentOnTop(alertController, animated: true)
        } else if canOpenInAR {
            openInAR()
        } else if canPresent {
            presentOnScreen()
        }
    }

    if url.absoluteString.hasPrefix(URLService.scheme) {
        if let service = url.urlService {
            switch service {
            case .link:
                UIApplication.shared.open(url)
            case let .openComponent(config, anchor, position):
                if let widgetConfiguration = widgetConfiguration {
                    Task {
                        switch config {
                        case let .url(url):
                            if let configURL = url.url,
                               let (data, _) = try? await URLSession.shared.data(from: configURL),
                               let component = try? JSONDecoder().decode(ViewElementComponent.self, from: data) {
                                processWidget(widgetConfiguration, configURL.absoluteString, component, anchor, position)
                            }
                        case let .json(json):
                            if let data = json.data(using: .utf8) {
                                let component = try! JSONDecoder().decode(ViewElementComponent.self, from: data)
                                processWidget(widgetConfiguration, json, component, anchor, position)
                            }
                        }
                    }
                }
            }
        }
    } else {
        if let url = URLService.link(href: url.absoluteString).url.url {
            UIApplication.shared.open(url)
        }
    }
}

//
//  AppDelegate.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/7/28.
//

import SafariServices
import SwiftUI
import SwiftyJSON
import UIKit

class MyApplication: UIApplication {
    override func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:], completionHandler completion: ((Bool) -> Void)? = nil) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.modalPresentationStyle = .popover
        presentOnTop(safariViewController)
    }
}

extension MyApplication: UIViewControllerTransitioningDelegate {}

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)

        #if !targetEnvironment(simulator)
            let rootVC = ARKitViewController()
            window.rootViewController = rootVC
        #else
            let rootVC = UIHostingController(rootView:
                ComponentView(.exampleArtworkWidget)
                    .environment(\.openURL, OpenURLAction { url in
                        return .handled
                    })
            )
            window.rootViewController = rootVC
        #endif
        window.makeKeyAndVisible()

        self.window = window
        return true
    }
}

extension UIApplication {
    func topController() -> UIViewController? {
        let keyWindow = sceneWindows.filter { $0.isKeyWindow }.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }

    var sceneWindows: [UIWindow] {
        UIApplication.shared.connectedScenes
            .first(where: { $0 is UIWindowScene })
            .flatMap { $0 as? UIWindowScene }?.windows ?? []
    }

    func presentOnTop(_ viewController: UIViewController, animated: Bool = true) {
        viewController.modalPresentationStyle = .popover
        topController()?.present(viewController, animated: animated)
    }

    func presentOnTop(_ viewController: UIViewController, detents: [UISheetPresentationController.Detent], animated: Bool = true) {
        viewController.modalPresentationStyle = .pageSheet
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = detents
        }

        topController()?.present(viewController, animated: animated)
    }
}

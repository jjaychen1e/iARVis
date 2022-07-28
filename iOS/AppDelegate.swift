//
//  AppDelegate.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/7/28.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)

        let rootVC = ARKitViewController()
        window.rootViewController = rootVC
        window.makeKeyAndVisible()

        self.window = window
        return true
    }
}

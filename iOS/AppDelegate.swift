//
//  AppDelegate.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/7/28.
//

import UIKit
import SwiftUI
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)

        #if !targetEnvironment(simulator)
            let rootVC = ARKitViewController()
            window.rootViewController = rootVC
        #else
            let chartConfiguration = ChartConfigurationJSONParser.default.parse(JSON(ChartConfigurationJSONParser.exampleJSONString1.data(using: .utf8)!)["chartConfig"])
            let rootVC = UIHostingController(rootView: ChartView(chartConfiguration: chartConfiguration))
            window.rootViewController = rootVC
        #endif
        window.makeKeyAndVisible()

        self.window = window
        return true
    }
}

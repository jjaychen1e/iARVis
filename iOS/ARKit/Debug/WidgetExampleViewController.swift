//
//  WidgetExampleViewController.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/8/1.
//

import Foundation
import SnapKit
import SwiftUI
import UIKit

struct WidgetExampleView: View {
    var body: some View {
        ComponentView(.example1)
    }
}

struct WidgetExampleView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetExampleView()
    }
}

class WidgetExampleViewController: UIViewController {
    // TODO: Change the frame with plane's size using a fixed DPI.
    private let width: CGFloat = 720
    private let height: CGFloat = 540
    private var squareWidth: CGFloat {
        max(width, height)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        // Tap gesture's location will be messed up if view is not square-sized when using SwiftUI
        view.frame = CGRect(x: 0, y: 0, width: squareWidth, height: squareWidth)
        view.isOpaque = false
        view.backgroundColor = .clear

        let hostingViewController = UIHostingController(rootView: WidgetExampleView(), ignoreSafeArea: true)
        hostingViewController.view.backgroundColor = .white
        addChildViewController(hostingViewController)
        hostingViewController.view.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
    }
}

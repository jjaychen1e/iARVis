//
//  WidgetExampleViewController.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/8/1.
//

import Foundation
import SwiftUI
import UIKit

struct WidgetExampleView: View {
    var body: some View {
        ScrollView {
            ForEach(0 ..< 100) { i in
                Text("\(i)")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct WidgetExampleView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetExampleView()
    }
}

class WidgetExampleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        view.isOpaque = false
        view.backgroundColor = .clear

        let hostingViewController = UIHostingController(rootView: WidgetExampleView(), ignoreSafeArea: true)
        hostingViewController.view.backgroundColor = .white
        addChildViewController(hostingViewController, addConstrains: true)
    }
}

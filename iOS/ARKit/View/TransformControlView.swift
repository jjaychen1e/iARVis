//
//  TransformControlView.swift
//  iARVis (iOS)
//
//  Created by Junjie Chen on 2022/9/15.
//

import SwiftUI
import UIKit

class TransformControlViewController: UIViewController {
    private var hostingViewController: UIHostingController<AnyView>!

    override func viewDidLoad() {
        super.viewDidLoad()

        overrideUserInterfaceStyle = .light

        let transformControlViewController = UIHostingController(rootView: AnyView(TransformControlView()), ignoreSafeArea: true)
        transformControlViewController.overrideUserInterfaceStyle = .light
        hostingViewController = transformControlViewController
        addChildViewController(transformControlViewController, addConstrains: true)
        transformControlViewController.view.backgroundColor = .clear
    }
}

struct TransformControlView: View {
    var body: some View {
        VStack(spacing: 2) {
            Text("Transformation")
                .font(.system(size: 21, weight: .medium))

            VStack(spacing: 0) {
                Color.gray.opacity(0.5).frame(height: 1).padding(.vertical, 8)
                TransformControlSliderView(label: "X")
                Color.gray.opacity(0.5).frame(height: 1).padding(.vertical, 8)
                TransformControlSliderView(label: "Y")
                Color.gray.opacity(0.5).frame(height: 1).padding(.vertical, 8)
                TransformControlSliderView(label: "Z")
                Color.gray.opacity(0.5).frame(height: 1).padding(.vertical, 8)
            }
        }
        .padding()
        .frame(width: 300)
        .background(.white)
        .cornerRadius(16, style: .continuous)
    }
}

private struct TransformControlSliderView: View {
    var label: String
    @State private var value: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("\(label): \(String(format: "%.2f", value))(cm)")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)

            Slider(
                value: $value,
                in: -100 ... 100,
                step: 0.01
            ) {} minimumValueLabel: {
                Text("-100")
                    .font(.system(size: 14, weight: .medium))
            } maximumValueLabel: {
                Text("100")
                    .font(.system(size: 14, weight: .medium))
            }
            .tint(.primary)
        }
    }
}

struct TransformControlView_Previews: PreviewProvider {
    static var previews: some View {
        TransformControlView()
            .previewLayout(.sizeThatFits)
    }
}

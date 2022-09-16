//
//  OnTouchOverlay.swift
//  iARVis
//
//  Created by Junjie Chen on 2022/9/16.
//

import SwiftUI

struct OnTouchOverlay: UIViewRepresentable {
    typealias Action = () -> Void

    let onTouch: Action

    init(onTouch: @escaping Action) {
        self.onTouch = onTouch
    }

    public func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)

        view.backgroundColor = .clear

        let press = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.onTouch))
        press.minimumPressDuration = 0.01
        press.cancelsTouchesInView = false
        press.delegate = context.coordinator
        view.addGestureRecognizer(press)

        return view
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.base = self
    }

    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        @usableFromInline
        var base: OnTouchOverlay

        public init(base: OnTouchOverlay) {
            self.base = base
        }

        @objc func onTouch(_ gesture: UILongPressGestureRecognizer) {
            if gesture.state == .began {
                base.onTouch()
            }
        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            true
        }
    }

    func makeCoordinator() -> Coordinator {
        .init(base: self)
    }
}

extension View {
    func onTouch(_ action: @escaping () -> Void) -> some View {
        overlay {
            OnTouchOverlay(onTouch: action)
        }
    }
}

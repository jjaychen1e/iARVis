//
//  PartialViewController.swift
//  PartialViewControllerSample
//
//  Created by 홍경표 on 2021/11/16.
//

import UIKit

open class PartialViewController: UIViewController {
    private let direction: PartialPresentationController.Direction
    private let viewSize: PartialPresentationController.SizePair
    private let isSwipeEnabled: Bool

    public init(
        direction: PartialPresentationController.Direction,
        viewSize: PartialPresentationController.SizePair,
        isSwipeEnabled: Bool = true
    ) {
        self.direction = direction
        self.viewSize = viewSize
        self.isSwipeEnabled = isSwipeEnabled

        super.init(nibName: nil, bundle: nil)

        if UIDevice.current.userInterfaceIdiom == .pad {
            // Custom PresentationController를 사용하기 위함
            modalPresentationStyle = .custom
            modalTransitionStyle = .crossDissolve // crossDissolve로 해놓고 디테일한 애니메이션은 직접 하는게 나음
            transitioningDelegate = self

            // statusBar를 presentedViewController 기준으로 설정할지
            modalPresentationCapturesStatusBarAppearance = true
        }
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("All UIs are code based, not nib.")
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }
}

extension PartialViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return PartialPresentationController(
            direction: direction,
            viewSize: viewSize,
            isSwipeEnabled: isSwipeEnabled,
            presentedViewController: presented,
            presenting: presenting
        )
    }
}

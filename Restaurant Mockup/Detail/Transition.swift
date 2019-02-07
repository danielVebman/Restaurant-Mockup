////
////  Transition.swift
////  Restaurant Mockup
////
////  Created by Daniel Vebman on 2/5/19.
////  Copyright © 2019 Daniel Vebman. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class TilePresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
//    private let segueInfo: SegueInfo
//
//    init(segueInfo: SegueInfo) {
//        self.segueInfo = segueInfo
//    }
//
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return 2
//    }
//
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let fromVC = transitionContext.viewController(forKey: .from),
//            let toVC = transitionContext.viewController(forKey: .to),
////            let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
//            else { return }
//
//        let containerView = transitionContext.containerView
//        let finalFrame = transitionContext.finalFrame(for: toVC)
//
//        snapshot.frame = segueInfo.cellFrame
////        containerView.addSubview(snapshot)
//        toVC.view.isHidden = true
//
//
//    }
//}

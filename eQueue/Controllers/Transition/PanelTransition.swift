//
//  PanelTransition.swift
//  eQueue
//
//  Created by Георгий Кашин on 24.04.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class PanelTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    init(from presented: UIViewController, to presenting: UIViewController) {
        super.init()
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = DimmPresentationController(presentedViewController: presented, presenting: presenting ?? source)
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentAnimation()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimation()
    }
}

extension PresentAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = self.animator(using: transitionContext)
        animator.startAnimation()
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return self.animator(using: transitionContext)
    }
}

class PresentAnimation: NSObject {
    let duration: TimeInterval = 0.3

    private func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        // transitionContext.view содержит всю нужную информацию, извлекаем её
        let to = transitionContext.view(forKey: .to)!
        let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!) // Тот самый фрейм, который мы задали в PresentationController
        // Смещаем контроллер за границу экрана
        to.frame = finalFrame.offsetBy(dx: 0, dy: finalFrame.height)
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            to.frame = finalFrame // Возвращаем на место, так он выезжает снизу
        }

        animator.addCompletion { (position) in
        // Завершаем переход, если он не был отменён
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        return animator
    }
}

class DismissAnimation: NSObject {
    let duration: TimeInterval = 0.3

    private func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        let from = transitionContext.view(forKey: .from)!
        let initialFrame = transitionContext.initialFrame(for: transitionContext.viewController(forKey: .from)!)

        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            from.frame = initialFrame.offsetBy(dx: 0, dy: initialFrame.height)
        }

        animator.addCompletion { (position) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        return animator
    }
}

extension DismissAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = self.animator(using: transitionContext)
        animator.startAnimation()
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return self.animator(using: transitionContext)
    }
}

enum ModalScaleState {
    case expanded
    case normal
}

class PresentationController: UIPresentationController {
    
    private var state: ModalScaleState = .normal
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = containerView!.bounds
        var height: CGFloat
        
        switch state {
        case .expanded:
            height = 0.8 * bounds.height
        case .normal:
            height = 0.5 * bounds.height
        }
        
        return CGRect(x: 0, y: bounds.height - height, width: bounds.width, height: height)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.addSubview(presentedView!)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    @objc func showPeopleButtonTapped() {
        var newState: ModalScaleState
        
        switch state {
        case .normal:
            newState = .expanded
        default:
            newState = .normal
        }
        
        changeScale(to: newState)
    }
    
    func changeScale(to state: ModalScaleState) {
        guard let presented = presentedView else { return }
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { [weak self] in
            guard let `self` = self else { return }
            
            // TODO: - FIX IT!!
            self.state = state
            presented.frame = self.frameOfPresentedViewInContainerView
            
            }, completion: { isFinished in
                self.state = state
        })
    }
}

class DimmPresentationController: PresentationController {
    private lazy var dimmView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        view.alpha = 0
        return view
    }()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        if let presentedVC = presentedViewController as? QueueActionsViewController {
            presentedVC.showPeopleButton.addTarget(self, action: #selector(showPeopleButtonTapped), for: .touchUpInside)
        }
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.insertSubview(dimmView, at: 0)
        performAlongsideTransitionPossible { [unowned self] in
            self.dimmView.alpha = 1
        }
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        dimmView.frame = containerView!.frame
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if !completed {
            self.dimmView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        performAlongsideTransitionPossible { [unowned self] in
            self.dimmView.alpha = 0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed {
            self.dimmView.removeFromSuperview()
        }
    }
    
    private func performAlongsideTransitionPossible(_ block: @escaping () -> Void) {
        guard let coordinator = self.presentedViewController.transitionCoordinator else {
            return block()
        }
        
        coordinator.animate(alongsideTransition: { _ in
            block()
        }, completion: nil)
    }
}

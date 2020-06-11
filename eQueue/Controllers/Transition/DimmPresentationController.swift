//
//  DimmPresentationController.swift
//  eQueue
//
//  Created by Георгий Кашин on 11.06.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class DimmPresentationController: PresentationController {
    
    // MARK: Lazy Properties
    private lazy var dimmView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        view.alpha = 0
        return view
    }()
    
    
    // MARK: Initializers
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        if let presentedVC = presentedViewController as? QueueActionsViewController {
            presentedVC.showPeopleButton.addTarget(self, action: #selector(showPeopleButtonTapped), for: .touchUpInside)
        }
    }
    
    
    // MARK: PresentationController Methods
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
    
    
    // MARK: Other Methods
    private func performAlongsideTransitionPossible(_ block: @escaping () -> Void) {
        guard let coordinator = self.presentedViewController.transitionCoordinator else {
            return block()
        }
        
        coordinator.animate(alongsideTransition: { _ in
            block()
        }, completion: nil)
    }
}

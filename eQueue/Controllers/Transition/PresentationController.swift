//
//  PresentationController.swift
//  eQueue
//
//  Created by Георгий Кашин on 11.06.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    
    // MARK: Stored Properties
    private var state: ModalScaleState = .normal
    
    
    // MARK: UIPresentationController Methods
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
    
    
    // MARK: Other Methods
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

// MARK: - OBJC Methods
extension PresentationController {
    // MARK: Button's Targets
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
}

//
//  QueueDetailViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 24.04.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class QueueActionsViewController: UIViewController {
    
    let hideButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "hide"), for: .normal)
        return button
    }()
    
    let startQueueButton: UIButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        
        setupUI()
        hideButton.addTarget(self, action: #selector(hideButtonTapped), for: .touchUpInside)
    }
    
    @objc private func hideButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UI
extension QueueActionsViewController {
    private func setupUI() {
        hideButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hideButton)
        
        NSLayoutConstraint.activate([
            hideButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            hideButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - SwiftUI
import SwiftUI

struct QueueActionsVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let queueActionsVC = QueueActionsViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<QueueActionsVCProvider.ContainerView>) -> QueueActionsViewController  {
            return queueActionsVC
        }
        
        func updateUIViewController(_ uiViewController: QueueActionsVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<QueueActionsVCProvider.ContainerView>) {
            
        }
    }
}

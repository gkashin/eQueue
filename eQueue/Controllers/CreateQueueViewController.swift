//
//  CreateQueueViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 11.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class CreateQueueViewController: UIViewController {
    
    let label = UILabel(text: "Label1")
    let textField = OneLineTextField(font: .avenir20())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let textFieldFormView = TextFieldFormView(label: label, textField: textField)
        textFieldFormView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textFieldFormView)

        textFieldFormView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textFieldFormView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
//        let stackView = UIStackView(arrangedSubviews: [label, textField], axis: .vertical, spacing: 10)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(stackView)
//        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

// MARK: - SwiftUI
import SwiftUI

struct CreateQueueVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let createQueueVC = CreateQueueViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<CreateQueueVCProvider.ContainerView>) -> CreateQueueViewController  {
            return createQueueVC
        }
        
        func updateUIViewController(_ uiViewController: CreateQueueVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<CreateQueueVCProvider.ContainerView>) {
            
        }
    }
}

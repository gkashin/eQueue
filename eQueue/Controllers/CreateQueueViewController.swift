//
//  CreateQueueViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 11.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class CreateQueueViewController: UIViewController {
    
    let titleLabel = UILabel(text: "Создать очередь")
    let nameLabel = UILabel(text: "Name")
    let descriptionLabel = UILabel(text: "Description")
    let startDateLabel = UILabel(text: "Start date")
    let nameTextField = OneLineTextField(font: .avenir20())
    let descriptionTextField = OneLineTextField(font: .avenir20())
    let startDateTextField = OneLineTextField(font: .avenir20())
    
    let createButton = UIButton(title: "Создать", backgroundColor: .buttonDark(), titleColor: .white, font: .avenir20(), isShadow: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
        
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    @objc private func createButtonTapped() {
        guard let name = nameTextField.text,
            let description = descriptionTextField.text,
            let startDate = startDateTextField.text,
            name != "",
            description != "",
            startDate != "" else {
                return
        }
        
        let queue = Queue(name: name, description: description, startDate: startDate, people: [], isOwnCreated: true)
        NotificationCenter.default.post(name: QueueViewController.updateNotificationName, object: nil, userInfo: ["queue": queue])
    }
}

// MARK: - UI
extension CreateQueueViewController {
    private func setupUI() {
        let nameTextFieldFormView = TextFieldFormView(label: nameLabel, textField: nameTextField)
        let descriptionTextFieldFormView = TextFieldFormView(label: descriptionLabel, textField: descriptionTextField)
        let startDateTextFieldFormView = TextFieldFormView(label: startDateLabel, textField: startDateTextField)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        let stackView = UIStackView(arrangedSubviews: [nameTextFieldFormView, descriptionTextFieldFormView, startDateTextFieldFormView], axis: .vertical, spacing: 0)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
        
        createButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.widthAnchor.constraint(equalToConstant: 100)
        ])
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

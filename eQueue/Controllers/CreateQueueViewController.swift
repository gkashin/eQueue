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
    let nameLabel = UILabel(text: "Название очереди")
    let descriptionLabel = UILabel(text: "Описание")
    let startDateLabel = UILabel(text: "Дата начала")
    let nameTextField = OneLineTextField(font: .avenir20())
    let descriptionTextField = OneLineTextField(font: .avenir20())
    let startDateTextField = OneLineTextField(font: .avenir20())
    
    let createButton = UIButton(title: "Создать", backgroundColor: .buttonDark(), titleColor: .white, font: .avenir20(), isShadow: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
        
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    @objc func keyboardWillShow() {
        print(12132)
        
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
        
        let queue = Queue(name: name, description: description, startDate: "", people: [], isOwnCreated: true)
        NotificationCenter.default.post(name: QueueViewController.updateNotificationName, object: nil, userInfo: ["queue": queue])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - UI
extension CreateQueueViewController {
    private func setupUI() {
        let nameTextFieldFormView = TextFieldFormView(label: nameLabel, textField: nameTextField)
        let descriptionTextFieldFormView = TextFieldFormView(label: descriptionLabel, textField: descriptionTextField)
        let startDateTextFieldFormView = TextFieldFormView(label: startDateLabel, textField: startDateTextField)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        startDateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        
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
            createButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc private func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        startDateTextField.text = dateFormatter.string(from: sender.date)
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

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
    
    let setCurrentDateLabel = UILabel(text: "Использовать текущую дату?", font: .avenir16())
    let setCurrentDateSwitch = UISwitch()
    
    let createButton = UIButton(title: "Создать", backgroundColor: .buttonDark(), titleColor: .white, font: .avenir20(), isShadow: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setCurrentDateSwitch.addTarget(self, action: #selector(setCurrentDateSwitchTapped), for: .touchUpInside)
        
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        view.frame.origin.y = 0 - 0.5 * keyboardSize.height
    }
    
    @objc func keyboardWillHide() {
        view.frame.origin.y = .zero
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
        
        let dateFormatter = DateFormatter()
        let date = dateFormatter.getDate(from: startDate)
        
        var queue = Queue(name: name, description: description, startDate: date, people: [], isOwnCreated: true)
        
        queue.people.append(User(username: "Егор", password: "pass", email: "email", firstName: "George", lastName: "Kashin"))
        queue.people.append(User(username: "Егор1", password: "pass", email: "email1", firstName: "Ivan", lastName: "Kuznetsov"))
        queue.people.append(User(username: "Егор2", password: "pass", email: "email2", firstName: "Dmitry", lastName: "Chuchin"))
        
        let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
        if setCurrentDateSwitch.isOn {
            if QueueViewController.currentQueue != nil {
                if QueueViewController.currentQueue!.isOwnCreated {
                    let alert = createAlert(withTitle: "У вас уже есть текущая очередь", andMessage: "")
                    present(alert, animated: true, completion: nil)
                }
            } else {
                QueueViewController.currentQueue = queue
                dismiss(animated: true) {
                    tabBarController.selectedIndex = 1
                }
            }
        } else {
            ControlViewController.upcomingQueues.append(queue)
            dismiss(animated: true) {
                tabBarController.selectedIndex = 2
            }
        }
    }
    
    @objc private func setCurrentDateSwitchTapped() {
        if setCurrentDateSwitch.isOn {
            let dateFormatter = DateFormatter()
            startDateTextField.text = dateFormatter.getString(from: Date())
        } else {
            startDateTextField.text = ""
        }
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
        datePicker.backgroundColor = .white
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        
        startDateTextField.inputView = datePicker
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        let stackView = UIStackView(arrangedSubviews: [nameTextFieldFormView, descriptionTextFieldFormView, startDateTextFieldFormView], axis: .vertical, spacing: 0)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        view.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            //            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0),
        ])
        
        setCurrentDateLabel.translatesAutoresizingMaskIntoConstraints = false
        setCurrentDateSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(setCurrentDateLabel)
        view.addSubview(setCurrentDateSwitch)
        
        NSLayoutConstraint.activate([
            setCurrentDateLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            setCurrentDateLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0),
            setCurrentDateSwitch.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            setCurrentDateSwitch.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0)
        ])
        
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc private func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        setCurrentDateSwitch.isOn = false
        startDateTextField.text = dateFormatter.getString(from: sender.date)
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

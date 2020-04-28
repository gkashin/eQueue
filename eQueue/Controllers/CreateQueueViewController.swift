//
//  CreateQueueViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 11.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class CreateQueueViewController: UIViewController {
    
    var completionHandler: ((Queue) -> Void)?
    
    let titleLabel = UILabel(text: "Создать очередь")
    let nameLabel = UILabel(text: "Название очереди")
    let descriptionLabel = UILabel(text: "Описание")
    let startDateLabel = UILabel(text: "Дата начала")
    let nameTextField = OneLineTextField(font: .avenir20())
    let descriptionTextField = OneLineTextField(font: .avenir20())
    let startDateTextField = OneLineTextField(font: .avenir20())
    
    let setCurrentDateLabel = UILabel(text: "Использовать текущую дату?", font: .avenir16())
    let setCurrentDateSwitch = UISwitch()
    
    var queue = Queue()
    var action = "Создать"
    
    let actionButton = UIButton(title: "Создать", backgroundColor: .buttonDark(), titleColor: .white, font: .avenir20(), isShadow: false)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(queue: Queue?, action: String?) {
        super.init(nibName: nil, bundle: nil)
        
        guard let queue = queue else { return }
        guard let action = action else { return }
        
        self.queue = queue
        self.action = action
        actionButton.setTitle(action, for: .normal)
        nameTextField.text = queue.name
        descriptionTextField.text = queue.description
        startDateTextField.text = queue.status == "upcoming" ? queue.startDate : nil
        titleLabel.text = "\(action) очередь"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setCurrentDateSwitch.addTarget(self, action: #selector(setCurrentDateSwitchTapped), for: .touchUpInside)
        
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        view.frame.origin.y = 0 - 0.5 * keyboardSize.height
    }
    
    @objc func keyboardWillHide() {
        view.frame.origin.y = .zero
    }
    
    @objc private func actionButtonTapped() {
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
        
        queue.name = name
        queue.description = description
        queue.startDate = DateFormatter().getString(from: date)
        queue.expectedTime = 10

        let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
        
        if action == "Создать" {
            NetworkManager.shared.createQueue(queue: queue) { queue in
                guard let queue = queue else { return }
                self.queue = queue
                
                ControlViewController.upcomingQueues.append(queue)
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        tabBarController.selectedIndex = 2
                    }
                }
            }
        }
        
        //        queue = Queue(name: name, description: description, startDate: date, people: [], isOwnCreated: true)
//        queue.isOwnCreated = true
        
        queue.people.append(User(username: "Егор", password: "pass", email: "email", firstName: "George", lastName: "Kashin"))
        queue.people.append(User(username: "Егор1", password: "pass", email: "email1", firstName: "Ivan", lastName: "Kuznetsov"))
        queue.people.append(User(username: "Егор2", password: "pass", email: "email2", firstName: "Dmitry", lastName: "Chuchin"))
        queue.people.append(User(username: "Егор", password: "pass", email: "email", firstName: "George", lastName: "Kashin"))
        queue.people.append(User(username: "Егор1", password: "pass", email: "email1", firstName: "Ivan", lastName: "Kuznetsov"))
        queue.people.append(User(username: "Егор2", password: "pass", email: "email2", firstName: "Dmitry", lastName: "Chuchin"))

//        if setCurrentDateSwitch.isOn {
//            if QueueViewController.currentQueue != nil {
//                if QueueViewController.currentQueue!.ownerId == SceneDelegate.user?.id {
//                    let alert = createAlert(withTitle: "У вас уже есть текущая очередь", andMessage: "")
//                    present(alert, animated: true, completion: nil)
//                }
//            } else {
//                QueueViewController.currentQueue = queue
//                dismiss(animated: true) {
//                    if tabBarController.selectedViewController?.navigationController != nil {
//                        print(#line, #function)
//                    }
//                    //                    tabBarController.selectedViewController?.navigationController?.popToRootViewController(animated: true)
//                    tabBarController.selectedIndex = 1
//                }
//            }
//        }
        
        if action == "Изменить" {
            let index = ControlViewController.upcomingQueues.firstIndex(where: { $0.id == queue.id })!
            if setCurrentDateSwitch.isOn {
                ControlViewController.upcomingQueues.remove(at: index)
                dismiss(animated: true)
            } else {
                ControlViewController.upcomingQueues[index] = queue
                completionHandler?(queue)
                dismiss(animated: true)
            }
        } else if action == "Повторить" {
            if !setCurrentDateSwitch.isOn {
                ControlViewController.upcomingQueues.append(queue)
                dismiss(animated: true)
                completionHandler?(queue)
            }
        } else if !setCurrentDateSwitch.isOn {
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
        
        view.addSubview(actionButton)
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 200),
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

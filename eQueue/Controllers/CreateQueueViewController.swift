//
//  CreateQueueViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 11.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class CreateQueueViewController: UIViewController {

    // MARK: Stored Properties
    var queue = Queue()
    var completionHandler: ((Queue) -> Void)?
    
    // MARK: Labels
    let titleLabel = UILabel(text: "Создать очередь")
    let nameLabel = UILabel(text: "Название очереди")
    let descriptionLabel = UILabel(text: "Описание")
    let startDateLabel = UILabel(text: "Дата начала")
    let setCurrentDateLabel = UILabel(text: "Использовать текущую дату?", font: .avenir16())
    
    // MARK: TextFields
    let nameTextField = OneLineTextField(font: .avenir20())
    let descriptionTextField = OneLineTextField(font: .avenir20())
    let startDateTextField = OneLineTextField(font: .avenir20())
    
    // MARK: Switches
    let setCurrentDateSwitch = UISwitch()
    
    // MARK: Buttons
    let createQueueButton = UIButton(title: "Создать", backgroundColor: .buttonDark(), titleColor: .white, font: .avenir20(), isShadow: false)
    
    // MARK: Initializers
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(queue: Queue?) {
        super.init(nibName: nil, bundle: nil)
        
        guard let queue = queue else { return }
        
        self.queue = queue
        nameTextField.text = queue.name
        descriptionTextField.text = queue.description
        startDateTextField.text = queue.status == "upcoming" ? queue.startDate : nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // Observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Targets
        setCurrentDateSwitch.addTarget(self, action: #selector(setCurrentDateSwitchTapped), for: .touchUpInside)
        createQueueButton.addTarget(self, action: #selector(createQueueButtonTapped), for: .touchUpInside)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - OBJC Methods
extension CreateQueueViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        view.frame.origin.y = 0 - 0.5 * keyboardSize.height
    }
    
    @objc func keyboardWillHide() {
        view.frame.origin.y = .zero
    }
    
    @objc private func createQueueButtonTapped() {
        guard let name = nameTextField.text,
            let description = descriptionTextField.text,
            let startDate = startDateTextField.text else {
                return
        }
        
        let error = Validators.isFilled(name: name, desc: description, startDate: startDate)
    
        switch error {
        case .nameNotFilled:
            self.present(self.createAlert(withTitle: "Ошибка", andMessage: error.localizedDescription), animated: true)
            return
        case .noError:
            let dateFormatter = DateFormatter()
            let date = dateFormatter.getDate(from: startDate)
            
            queue.name = name
            queue.description = description
            queue.startDate = DateFormatter().getString(from: date)
            queue.expectedTime = 10
            
            NetworkManager.shared.createQueue(queue: queue) { queue in
                guard var queue = queue else { return }
                self.queue = queue
                
                queue.status = "upcoming"
                queue.queue = [User]()
                
                
                DispatchQueue.main.async {
                    let qrCodeVC = QRCodeViewController(qrWithText: "\(queue.id)")
                    qrCodeVC.createQueueDelegate = self
                    
                    self.present(qrCodeVC, animated: true)
                }
            }
            return
        case .descNotFilled:
            self.present(self.createAlert(withTitle: "Ошибка", andMessage: error.localizedDescription), animated: true)
            return
        case .dateNotFilled:
            self.present(self.createAlert(withTitle: "Ошибка", andMessage: error.localizedDescription), animated: true)
            return
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
    
    @objc private func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        setCurrentDateSwitch.isOn = false
        startDateTextField.text = dateFormatter.getString(from: sender.date)
    }
}

// MARK: - UI
extension CreateQueueViewController {
    private func setupUI() {
        view.backgroundColor = .white
        
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
        
        view.addSubview(createQueueButton)
        
        createQueueButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            createQueueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            createQueueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createQueueButton.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
}

// MARK: - CreateQueueDelegate
extension CreateQueueViewController: CreateQueueDelegate {
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}

//
//  SignUpViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 04.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: Delegates
    weak var delegate: AuthNavigatingDelegate?
    
    
    // MARK: Labels
    let welcomeLabel = UILabel(text: "Рады видеть Вас!", font: .avenir26())
    let usernameLabel = UILabel(text: "Имя")
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Пароль")
    let confirmPasswordLabel = UILabel(text: "Подтвердите пароль")
    let alreadyOnBoardLabel = UILabel(text: "Already onboard?")
    
    
    // MARK: TextFields
    let usernameTextField = OneLineTextField(font: .avenir20())
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    let confirmPasswordTextField = OneLineTextField(font: .avenir20())
    
    
    // MARK: Buttons
    let signUpButton = UIButton(title: "Зарегистрироваться", backgroundColor: .buttonDark(), titleColor: .white, isShadow: false)
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.buttonRed(), for: .normal)
        button.titleLabel?.font = .avenir20()
        
        return button
    }()
    
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // Targets
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        // Observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - OBJC Methods
extension SignUpViewController {
    // MARK: Button's Targets
    @objc private func loginButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.toLoginVC()
        }
    }
    
    @objc private func signUpButtonTapped() {
        guard let username = usernameTextField.text else {
            return
        }
        guard let email = emailTextField.text else {
            return
        }
        guard let password = passwordTextField.text else {
            return
        }
        guard let confirmPassword = confirmPasswordTextField.text else {
            return
        }
        
        let error = Validators.isFilled(username: username, email: email, password: password, confirmPassword: confirmPassword)
        
        switch error {
        case .emailNotFilled:
            self.present(self.createAlert(withTitle: "Ошибка", andMessage: error.localizedDescription), animated: true)
            return
        case .passwordNotFilled:
            self.present(self.createAlert(withTitle: "Ошибка", andMessage: error.localizedDescription), animated: true)
            return
        case .invalidEmail:
            self.present(self.createAlert(withTitle: "Ошибка", andMessage: error.localizedDescription), animated: true)
            return
        case .noError:
                    let user = User(username: username, email: email, password: password)
            
            NetworkManager.shared.register(user: user) { user in
                guard let _ = user else { return }
                
                DispatchQueue.main.async {
                    let infoAlert = UIAlertController(title: "Вы успешно зарегистрировались", message: "Пройдите по ссылке в письме активации, отправленному на Ваш email!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "ОК", style: .default) { _ in
                        self.dismiss(animated: true) {
                            //                        self.delegate?.dismiss()
                            self.delegate?.toLoginVC()
                        }
                        
                    }
                    infoAlert.addAction(okAction)
                    
                    self.present(infoAlert, animated: true)
                }
            }
            break
        case .passwordsNotMatched:
            self.present(self.createAlert(withTitle: "Ошибка", andMessage: error.localizedDescription), animated: true)
            return
        case .wrongData:
            break
        case .confirmPasswordNotFilled:
            self.present(self.createAlert(withTitle: "Ошибка", andMessage: error.localizedDescription), animated: true)
            return
        case .nameNotFilled:
            self.present(self.createAlert(withTitle: "Ошибка", andMessage: error.localizedDescription), animated: true)
            return
        }
    }
    
    
    // MARK: Observers
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        view.frame.origin.y = 0 - 0.6 * keyboardSize.height
    }
    
    @objc func keyboardWillHide() {
        view.frame.origin.y = .zero
    }
}

// MARK: - UI
extension SignUpViewController {
    private func setupUI() {
        view.backgroundColor = .white
        setupConstraints()
    }
    
    private func setupConstraints() {
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        let usernameStackView = UIStackView(arrangedSubviews: [usernameLabel, usernameTextField], axis: .vertical, spacing: 0)
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
        let confirmPasswordStackView = UIStackView(arrangedSubviews: [confirmPasswordLabel, confirmPasswordTextField], axis: .vertical, spacing: 0)
        
        usernameTextField.placeholder = "Например, Иван Кузнецов"
        signUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let stackView = UIStackView(arrangedSubviews: [usernameStackView,
                                                       emailStackView,
                                                       passwordStackView,
                                                       confirmPasswordStackView,
                                                       signUpButton
            ],
                                    axis: .vertical,
                                    spacing: 40
        )
        
        loginButton.contentHorizontalAlignment = .leading
        let bottomStackView = UIStackView(arrangedSubviews: [alreadyOnBoardLabel, loginButton], axis: .horizontal, spacing: 10)
        bottomStackView.alignment = .firstBaseline
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}

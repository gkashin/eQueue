//
//  LoginViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 04.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Delegates
    weak var delegate: AuthNavigatingDelegate?
    
    
    // MARK: Labels
    let welcomeLabel = UILabel(text: "Добро пожаловать!", font: .avenir26())
    let loginWithLabel = UILabel(text: "Войти с помощью")
    let orLabel = UILabel(text: "или")
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Пароль")
    let needAnAccountLabel = UILabel(text: "Нужен аккаунт?", font: .avenir20())
    
    
    // MARK: Buttons
    let googleButton = UIButton(title: "Google", backgroundColor: .white, titleColor: .black, isShadow: true)
    let loginButton = UIButton(title: "Войти", backgroundColor: .buttonDark(), titleColor: .white, isShadow: false)
   
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(.buttonRed(), for: .normal)
        button.titleLabel?.font = .avenir20()
        
        return button
    }()
    
    
    // MARK: TextFields
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    
    
    // MARK: Initializers
    init(email: String = "") {
        super.init(nibName: nil, bundle: nil)
        emailTextField.text = email
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // Targets
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        
        // Observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - OBJC Methods
extension LoginViewController {
    // MARK: Button's Targets
    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        let error = Validators.isFilled(email: email, password: password)
        
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
            NetworkManager.shared.login(email: email, password: password) { statusCode in
                if statusCode == 200 {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                        self.delegate?.dismiss()
                    }
                    
                    NetworkManager.shared.getCurrentUser { user in
                        guard let user = user else { return }
                        SceneDelegate.user = user
                    }
                } else {
                    DispatchQueue.main.async {
                        self.present(self.createAlert(withTitle: "Ошибка", andMessage: AuthError.wrongData.localizedDescription), animated: true)
                    }
                }
            }
            break
        case .passwordsNotMatched:
            break
        case .wrongData:
            break
        case .confirmPasswordNotFilled:
            break
        case .nameNotFilled:
            break
        }
    }
    
    @objc private func signUpButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.toSignUpVC()
        }
    }
    
    @objc private func googleButtonTapped() {
        // TODO: Google Auth
    }
    
    
    // MARK: Observers
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        view.frame.origin.y = 0 - keyboardSize.height
    }
    
    @objc func keyboardWillHide() {
        view.frame.origin.y = .zero
    }
}

// MARK: - UI
extension LoginViewController {
    private func setupUI() {
        view.backgroundColor = .white
        googleButton.customizeGoogleButton()
        setupConstraints()
    }
    
    private func setupConstraints() {
        passwordTextField.isSecureTextEntry = true
        let loginWithView = ButtonFormView(label: loginWithLabel, button: googleButton)
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
        
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let stackView = UIStackView(arrangedSubviews: [loginWithView,
                                                       orLabel,
                                                       emailStackView,
                                                       passwordStackView,
                                                       loginButton
            ],
                                    axis: .vertical,
                                    spacing: 40)
        
        signUpButton.contentHorizontalAlignment = .leading
        let bottomStackView = UIStackView(arrangedSubviews: [needAnAccountLabel, signUpButton], axis: .horizontal, spacing: 10)
        bottomStackView.alignment = .firstBaseline
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}

// MARK: - SwiftUI
import SwiftUI

struct LoginVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let loginVC = LoginViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<LoginVCProvider.ContainerView>) -> LoginViewController {
            return loginVC
        }
        
        func updateUIViewController(_ uiViewController: LoginVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<LoginVCProvider.ContainerView>) {
            
        }
    }
}


//
//  AuthViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 04.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    // MARK: Delegates
    weak var updateUIDelegate: UpdateUIDelegate?
    
    
    // MARK: VCs
    let loginVC = LoginViewController()
    let signUpVC = SignUpViewController()
    
    
    // MARK: Image Views
    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "queue_logo"), contentMode: .scaleAspectFill)
    
    
    // MARK: Labels
    let alreadyOnboardLabel = UILabel(text: "Уже зарегистрированы?")
    let emailLabel = UILabel(text: "Или зарегистрируйтсь с")
    let googleLabel = UILabel(text: "Начните с")
    
    
    // MARK: Buttons
    let emailButton = UIButton(title: "Email", backgroundColor: .buttonDark(), titleColor: .white, isShadow: false)
    let googleButton = UIButton(title: "Google", backgroundColor: .white, titleColor: .black, isShadow: true)
    let loginButton = UIButton(title: "Войти", backgroundColor: .white, titleColor: .buttonRed(), isShadow: true)

    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        loginVC.delegate = self
        signUpVC.delegate = self
        
        // Targets
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
    }
}

// MARK: - OBJC Methods
extension AuthViewController {
    // MARK: Button's Targets
    @objc private func emailButtonTapped() {
        present(signUpVC, animated: true)
    }
    
    @objc private func loginButtonTapped() {
        present(loginVC, animated: true)
    }
    
    @objc private func googleButtonTapped() {
        // TODO: Google Auth
    }
}

// MARK: - UI
extension AuthViewController {
    private func setupUI() {
        googleButton.customizeGoogleButton()
        view.backgroundColor = .white
        setupConstraints()
    }
    
    private func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -40),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let googleView = ButtonFormView(label: googleLabel, button: googleButton)
        let emailView = ButtonFormView(label: emailLabel, button: emailButton)
        let loginView = ButtonFormView(label: alreadyOnboardLabel, button: loginButton)
        
        let stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView], axis: .vertical, spacing: 40)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: -70),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}

// MARK: - AuthNavigatingDelegate
extension AuthViewController: AuthNavigatingDelegate {
    func toLoginVC() {
        present(loginVC, animated: true)
    }
    
    func toSignUpVC() {
        present(signUpVC, animated: true)
    }
    
    func dismiss() {
        dismiss(animated: true) {
            self.updateUIDelegate?.updateUI()
        }
    }
}


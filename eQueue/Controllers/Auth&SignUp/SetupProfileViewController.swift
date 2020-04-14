//
//  SetupProfileViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 08.04.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class SetupProfileViewController: UIViewController {
    
    let welcomeLabel = UILabel(text: "Настроить профиль", font: .avenir26())
    
    let nameLabel = UILabel(text: "Имя")
    let surnameLabel = UILabel(text: "Фамилия")
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Пароль")
    
    let nameTextField = OneLineTextField(font: .avenir20())
    let surnameTextField = OneLineTextField(font: .avenir20())
    let emailTextField = OneLineTextField(font: .avenir20())
    let phoneNumberTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    
    let setupProfileButton = UIButton(title: "Setup profile!", backgroundColor: .buttonDark(), titleColor: .white, isShadow: false, cornerRadius: 4)
    
    let fullImageView = AddPhotoView()
    
    //    private var currentUser: User
    
    //    init() {
    //        self.currentUser = currentUser
    //        super.init(nibName: nil, bundle: nil)
    
    //        if let username = currentUser.displayName {
    //            fullNameTextField.text = username
    //        }
    //
    //        if let photoURL = currentUser.photoURL {
    //            fullImageView.circleImageView.sd_setImage(with: photoURL, completed: nil)
    //        }
    //    }
    
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        
        setupProfileButton.addTarget(self, action: #selector(setupProfileButtonTapped), for: .touchUpInside)
        fullImageView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    @objc private func setupProfileButtonTapped() {
        
    }
    
    @objc private func plusButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
}

// MARK: - Setup Constraints
extension SetupProfileViewController {
    private func setupUI() {
        let dataStackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField, surnameLabel, surnameTextField], axis: .vertical, spacing: 20)
        
        if let user = SceneDelegate.user {
            nameTextField.text = user.firstName
            surnameTextField.text = user.lastName
            emailTextField.text = user.email
            
            dataStackView.addArrangedSubview(emailLabel)
            dataStackView.addArrangedSubview(emailTextField)
            dataStackView.addArrangedSubview(passwordLabel)
            dataStackView.addArrangedSubview(passwordTextField)
        }
        
        setupProfileButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let stackView = UIStackView(arrangedSubviews: [
            dataStackView,
            setupProfileButton
        ], axis: .vertical, spacing: 30)
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        fullImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.addSubview(welcomeLabel)
        scrollView.addSubview(fullImageView)
        scrollView.addSubview(dataStackView)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 100),
            welcomeLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            fullImageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
            fullImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            dataStackView.topAnchor.constraint(equalTo: fullImageView.bottomAnchor, constant: 40),
            dataStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40),
            dataStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40),
            dataStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80),
            
            stackView.topAnchor.constraint(equalTo: dataStackView.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80),
        ])
    }
}

// MARK: - UIImagePickerControllerDelegate
extension SetupProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        fullImageView.circleImageView.image = image
    }
}

// MARK: - SwiftUI
import SwiftUI

struct SetupProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let setupProfileVC = SetupProfileViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<SetupProfileVCProvider.ContainerView>) -> SetupProfileViewController {
            return setupProfileVC
        }
        
        func updateUIViewController(_ uiViewController: SetupProfileVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SetupProfileVCProvider.ContainerView>) {
            
        }
    }
}


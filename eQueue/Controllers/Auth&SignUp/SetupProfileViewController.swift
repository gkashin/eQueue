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
    
    let saveButton = UIButton(title: "Сохранить", backgroundColor: .buttonDark(), titleColor: .white, isShadow: false, cornerRadius: 4)
    
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
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        fullImageView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func saveButtonTapped() {
        guard let name = nameTextField.text,
            let surname = surnameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let avatarImage = fullImageView.circleImageView.image,
            name != "",
            surname != "",
            email != "",
            password != "" else {
                return
        }
        
        SceneDelegate.user?.firstName = name
        SceneDelegate.user?.lastName = surname
        SceneDelegate.user?.avatarData = avatarImage.pngData()!
        SceneDelegate.user?.email = email
        SceneDelegate.user?.password = password
        
        dismiss(animated: true) {
            let tabBarVC = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
            let navigationVC = tabBarVC.viewControllers?.first! as! UINavigationController
            let rootVC = navigationVC.viewControllers.first as! MainViewController
            rootVC.updateProfileButton()
        }
    }
    
    @objc private func plusButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        view.frame.origin.y = 0 - 0.6 * keyboardSize.height
    }
    
    @objc func keyboardWillHide() {
        view.frame.origin.y = .zero
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - Setup Constraints
extension SetupProfileViewController {
    private func setupUI() {
        let dataStackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField, surnameLabel, surnameTextField], axis: .vertical, spacing: 10)
        
        if let user = SceneDelegate.user {
            nameTextField.text = user.firstName
            surnameTextField.text = user.lastName
            fullImageView.circleImageView.image = UIImage(data: user.avatarData)
            emailTextField.text = user.email
            passwordTextField.text = user.password
            
            dataStackView.addArrangedSubview(emailLabel)
            dataStackView.addArrangedSubview(emailTextField)
            dataStackView.addArrangedSubview(passwordLabel)
            dataStackView.addArrangedSubview(passwordTextField)
        }
        
        saveButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let stackView = UIStackView(arrangedSubviews: [
            dataStackView,
            saveButton
        ], axis: .vertical, spacing: 30)
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        fullImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(fullImageView)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            fullImageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            fullImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: fullImageView.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
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


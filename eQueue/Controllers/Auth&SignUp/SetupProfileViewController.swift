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
    //    let surnameLabel = UILabel(text: "Фамилия")
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Пароль")
    
    let nameTextField = OneLineTextField(font: .avenir20())
    //    let surnameTextField = OneLineTextField(font: .avenir20())
    let emailTextField = OneLineTextField(font: .avenir20())
    let phoneNumberTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    
    var exitButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "exit"), for: .normal)
        return button
    }()
    
    let saveButton = UIButton(title: "Сохранить", backgroundColor: .buttonDark(), titleColor: .white, isShadow: false, cornerRadius: 4)
    
    let fullImageView = AddPhotoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        fullImageView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func exitButtonTapped() {
        SceneDelegate.defaults.set("", forKey: "token")
        SceneDelegate.user = nil
        
        updateProfileButton()
    }
    
    @objc private func saveButtonTapped() {
        guard let username = nameTextField.text,
            //            let surname = surnameTextField.text,
            //            let email = emailTextField.text,
            let password = passwordTextField.text,
            let avatarImage = fullImageView.circleImageView.image
            else {
                return
        }
        
        let error = Validators.isFilled(name: username, password: password)
        
        switch error {
            
        case .nameNotFilled:
            self.present(self.createAlert(withTitle: "Ошибка", andMessage: error.localizedDescription), animated: true)
            return
        case .noError:
            let confirmAlert = UIAlertController(title: "Введите текущий пароль", message: "", preferredStyle: .alert)
            confirmAlert.addTextField { textField in
                textField.isSecureTextEntry = true
            }
            
            let confirmAction = UIAlertAction(title: "Подтвердить", style: .default) { _ in
                let oldPassword = confirmAlert.textFields!.first?.text
                guard oldPassword != nil && oldPassword != "" else {
                    DispatchQueue.main.async {
                        self.present(self.createAlert(withTitle: "Ошибка", andMessage: EditProfileError.passwordNotFilled.localizedDescription), animated: true)
                    }
                    return
                }
                
                NetworkManager.shared.updateUsername(username: username, password: oldPassword!) { statusCode in
                    guard statusCode == 204 else {
                        DispatchQueue.main.async {
                            self.present(self.createAlert(withTitle: "Ошибка", andMessage:
                                EditProfileError.passwordNotMatched.localizedDescription), animated: true)
                        }
                        return
                    }
                    
                    SceneDelegate.user?.username = username
                    
                    //                NetworkManager.shared.updateSurname(surname: surname, password: oldPassword!) { statusCode in
                    //                    guard statusCode == 204 else { return }
                    //
                    //                    SceneDelegate.user?.lastName = surname
                    
                    NetworkManager.shared.updatePassword(newPassword: password, password: oldPassword!) { statusCode in
                        guard statusCode == 204 else { return }
                        
                        SceneDelegate.user?.avatarData = avatarImage.pngData()!
                        SceneDelegate.user?.password = password
                        //        SceneDelegate.user?.email = email
                        //        if !password.isEmpty {
                        //            SceneDelegate.user?.password = password
                        //        }
                        
                        DispatchQueue.main.async {
                            self.updateProfileButton()
                        }
                        //                    }
                    }
                }
            }
            
            confirmAlert.addAction(confirmAction)
            
            present(confirmAlert, animated: true)
            return
        case .passwordNotFilled:
            self.present(self.createAlert(withTitle: "Ошибка", andMessage: error.localizedDescription), animated: true)
            return
        case .passwordNotMatched:
            break
        }
    }
    
    private func updateProfileButton() {
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

// MARK: - UI
extension SetupProfileViewController {
    private func setupUI() {
        passwordTextField.isSecureTextEntry = true
        var welcomeLabelDistance: CGFloat = 60
        var fullImageViewDistance: CGFloat = 30
        var stackViewSpacing: CGFloat = 60
        var stackViewDistance: CGFloat = 60
        
        let dataStackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField], axis: .vertical, spacing: 20)
        
        if let user = SceneDelegate.user {
            nameTextField.text = user.username
            //            surnameTextField.text = user.lastName
            if let avatarData = user.avatarData {
                fullImageView.circleImageView.image = UIImage(data: avatarData)
            }
            emailTextField.text = user.email
            emailTextField.isEnabled = false
            passwordTextField.text = user.password
            
            dataStackView.addArrangedSubview(emailLabel)
            dataStackView.addArrangedSubview(emailTextField)
            dataStackView.addArrangedSubview(passwordLabel)
            dataStackView.addArrangedSubview(passwordTextField)
            
            welcomeLabelDistance = 30
            fullImageViewDistance = 20
            stackViewSpacing = 30
            stackViewDistance = 30
            
            dataStackView.spacing = 20
        }
        
        saveButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let stackView = UIStackView(arrangedSubviews: [
            dataStackView,
            saveButton
        ], axis: .vertical, spacing: stackViewSpacing)
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        fullImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(fullImageView)
        view.addSubview(stackView)
        
        if SceneDelegate.user != nil {
            view.addSubview(exitButton)
            NSLayoutConstraint.activate([
                exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
                exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            ])
        }
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: welcomeLabelDistance),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            fullImageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: fullImageViewDistance),
            fullImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: fullImageView.bottomAnchor, constant: stackViewDistance),
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


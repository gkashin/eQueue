//
//  SetupProfileViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 08.04.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class SetupProfileViewController: UIViewController {
    
    let welcomeLabel = UILabel(text: "Set up profile", font: .avenir26())
    
    let nameLabel = UILabel(text: "Name")
    let surnameLabel = UILabel(text: "Surname")
    
    let fullNameTextField = OneLineTextField(font: .avenir20())
    let surnameTextField = OneLineTextField(font: .avenir20())
    
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
        setupConstraints()
        
        setupProfileButton.addTarget(self, action: #selector(goToChatsButtonTapped), for: .touchUpInside)
        fullImageView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    @objc private func goToChatsButtonTapped() {
//        FirestoreService.shared.saveProfileWith(
//            id: currentUser.uid,
//            email: currentUser.email!,
//            username: fullNameTextField.text,
//            avatarImage: fullImageView.circleImageView.image,
//            description: aboutMeTextField.text,
//            sex: sexSegmentedControl.titleForSegment(at: sexSegmentedControl.selectedSegmentIndex)) { result in
//                switch result {
//                case .success(let muser):
//                    self.showAlert(with: "Success!", and: "Have a nice chat!") {
//                        let mainTabBar = MainTabBarController(currentUser: muser)
//                        mainTabBar.modalPresentationStyle = .fullScreen
//                        self.present(mainTabBar, animated: true)
//                    }
//                case .failure(let error):
//                    self.showAlert(with: "Error!", and: error.localizedDescription)
//                }
//        }
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
    private func setupConstraints() {
        
        let nameStackView = UIStackView(arrangedSubviews: [nameLabel, fullNameTextField, surnameLabel, surnameTextField], axis: .vertical, spacing: 20)
        
        setupProfileButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let stackView = UIStackView(arrangedSubviews: [
            nameStackView,
            setupProfileButton
        ], axis: .vertical, spacing: 40)
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        fullImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(fullImageView)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            fullImageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
            fullImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: fullImageView.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
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


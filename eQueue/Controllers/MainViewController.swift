//
//  MainViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 09.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "avatar")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let profileButton = UIButton()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "logo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let scanQrButton = UIButton(title: "Отсканировать QR", backgroundColor: .white, titleColor: .black, font: .avenir20(), isShadow: true, cornerRadius: 4)
    let findQueueButton = UIButton(title: "Найти очередь", backgroundColor: .white, titleColor: .black, font: .avenir20(), isShadow: true, cornerRadius: 4)
    let createQueueButton = UIButton(title: "Создать", backgroundColor: .darkGray, titleColor: .white, font: .avenir20(), isShadow: false, cornerRadius: 4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainWhite()
        title = "Главная"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupUI()
        
        scanQrButton.addTarget(self, action: #selector(scanQrButtonTapped), for: .touchUpInside)
        createQueueButton.addTarget(self, action: #selector(createQueueButtonTapped), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
    }
    
    @objc private func profileButtonTapped() {
        if SceneDelegate.user != nil {
            let setupProfileVC = SetupProfileViewController()
            present(setupProfileVC, animated: true)
        } else {
            let setupProfileVC = SetupProfileViewController()
            present(setupProfileVC, animated: true)
//            let authVC = AuthViewController()
//            present(authVC, animated: true)
        }
    }
    
    @objc private func scanQrButtonTapped() {
//        let scanQrVC = ScanQRViewController()
//        present(scanQrVC, animated: true)
        
        let token = SceneDelegate.defaults.object(forKey: "token") as? String ?? ""

        NetworkManager.shared.verifyToken(token: token) { statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async {
                    let scanQrVC = ScanQRViewController()
                    self.present(scanQrVC, animated: true)
                }
            } else {
                DispatchQueue.main.async {
//                    let authVC = AuthViewController()
//                    self.present(authVC, animated: true)
                    let scanQrVC = ScanQRViewController()
                    self.present(scanQrVC, animated: true)
                }
            }
        }
    }
    
    @objc private func createQueueButtonTapped() {
        let token = SceneDelegate.defaults.object(forKey: "token") as? String ?? ""

        NetworkManager.shared.verifyToken(token: token) { statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async {
                    let createQueueVC = CreateQueueViewController()
                    self.present(createQueueVC, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    let createQueueVC = CreateQueueViewController()
                    self.present(createQueueVC, animated: true)
//                    let authVC = AuthViewController()
//                    self.present(authVC, animated: true)
                }
            }
        }
        
//        let createQueueVC = CreateQueueViewController()
//        present(createQueueVC, animated: true)
    }
    
    public func updateProfileButton() {
        var image: UIImage
        if let user = SceneDelegate.user {
            guard let avatarImage = UIImage(data: user.avatarData) else { return }
            image = avatarImage
        } else {
            image = #imageLiteral(resourceName: "circle")
        }
        profileButton.setBackgroundImage(image, for: .normal)
    }
}

// MARK: - UI
extension MainViewController {
    private func setupUI() {
        updateProfileButton()
        
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
//        navigationController.addSubview(profileButton)
        navigationController?.navigationBar.addSubview(profileButton)
        view.addSubview(logoImageView)
        let buttonStackView = UIStackView(arrangedSubviews: [scanQrButton, findQueueButton, createQueueButton], axis: .vertical, spacing: 10)
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.setCustomSpacing(40, after: findQueueButton)
        buttonStackView.distribution = .fillEqually
        view.addSubview(buttonStackView)
        
        profileButton.layer.cornerRadius = 45
        profileButton.clipsToBounds = true
        NSLayoutConstraint.activate([
            profileButton.topAnchor.constraint(equalTo: navigationController!.navigationBar.topAnchor, constant: 20),
            profileButton.trailingAnchor.constraint(equalTo: navigationController!.navigationBar.trailingAnchor, constant: -20),
            profileButton.heightAnchor.constraint(equalToConstant: 90),
            profileButton.widthAnchor.constraint(equalToConstant: 90)
        ])
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 0.3 * view.frame.size.height),
            logoImageView.widthAnchor.constraint(equalToConstant: 0.3 * view.frame.size.width)
        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
        ])
    }
}

// MARK: - SwiftUI
import SwiftUI

struct MainVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let tabBarVC = MainTabBarController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<MainVCProvider.ContainerView>) -> MainTabBarController  {
            return tabBarVC
        }
        
        func updateUIViewController(_ uiViewController: MainVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<MainVCProvider.ContainerView>) {
            
        }
    }
}

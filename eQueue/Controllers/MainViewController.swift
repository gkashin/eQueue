//
//  MainViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 09.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
    
    let scanQrButton = UIButton(title: "Отсканировать QR", backgroundColor: .white, titleColor: .black, font: .avenir20(), isShadow: true, cornerRadius: 4)
    let findQueueButton = UIButton(title: "Найти очередь", backgroundColor: .white, titleColor: .black, font: .avenir20(), isShadow: true, cornerRadius: 4)
    let createQueueButton = UIButton(title: "Создать", backgroundColor: .darkGray, titleColor: .white, font: .avenir20(), isShadow: false, cornerRadius: 4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainWhite()
        title = "Главная"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupConstraints()
        
        createQueueButton.addTarget(self, action: #selector(createQueueButtonTapped), for: .touchUpInside)
    }
    
    @objc private func createQueueButtonTapped() {
        let createQueueVC = CreateQueueViewController()
        present(createQueueVC, animated: true)
    }
}

// MARK: - UI
extension MainViewController {
    private func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        let buttonStackView = UIStackView(arrangedSubviews: [scanQrButton, findQueueButton, createQueueButton], axis: .vertical, spacing: 30)
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.setCustomSpacing(70, after: findQueueButton)
        view.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
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

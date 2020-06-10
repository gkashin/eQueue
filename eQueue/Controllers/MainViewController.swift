//
//  MainViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 09.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: Image Views
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "avatar")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "logo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: Buttons
    let profileButton = UIButton()
    let scanQrButton = UIButton(title: "Отсканировать QR", backgroundColor: .white, titleColor: .black, font: .avenir20(), isShadow: true, cornerRadius: 4)
    let findQueueButton = UIButton(title: "Найти очередь", backgroundColor: .white, titleColor: .black, font: .avenir20(), isShadow: true, cornerRadius: 4)
    let createQueueButton = UIButton(title: "Создать", backgroundColor: .darkGray, titleColor: .white, font: .avenir20(), isShadow: false, cornerRadius: 4)
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainWhite()
        title = "Главная"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupUI()
        
        // Add button targets
        scanQrButton.addTarget(self, action: #selector(scanQrButtonTapped), for: .touchUpInside)
        createQueueButton.addTarget(self, action: #selector(createQueueButtonTapped), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
    }
    
    // MARK: Button's Targets
    @objc private func profileButtonTapped() {
        if SceneDelegate.user != nil {
            // If user is logged, show SetupProfileViewController
            let setupProfileVC = SetupProfileViewController()
            present(setupProfileVC, animated: true)
        } else {
            // If not, show Authentication View Controller
            let authVC = AuthViewController()
            present(authVC, animated: true)
        }
    }
    
    @objc private func scanQrButtonTapped() {
        // Trying to get local token
        let token = SceneDelegate.defaults.object(forKey: "token") as? String ?? ""

        NetworkManager.shared.verifyToken(token: token) { statusCode in
            // If token is verified
            if statusCode == 200 {
                // Trying to get current queue
                NetworkManager.shared.getCurrentQueue { queue in
                    let infoAlert = self.createAlert(withTitle: "Вы уже стоите в очереди", andMessage: "")
                    
                    if queue != nil {
                        self.presentAlert(alert: infoAlert)
                        return
                    }
                    
                    // Trying to get current owner queue
                    NetworkManager.shared.getCurrentOwnerQueue { queue in
                        if queue != nil {
                            self.presentAlert(alert: infoAlert)
                            return
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    // Present Scan QR View Controller
                    let scanQrVC = ScanQRViewController()
                    self.present(scanQrVC, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    // Present Authentication View Controller
                    let authVC = AuthViewController()
                    authVC.updateUIDelegate = self
                    self.present(authVC, animated: true)
                }
            }
        }
    }
    
    /// Present given alert in the main thread
    /// - Parameter alert: Alert to be presented
    private func presentAlert(alert: UIAlertController) {
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    @objc private func createQueueButtonTapped() {
        let token = SceneDelegate.defaults.object(forKey: "token") as? String ?? ""

        NetworkManager.shared.verifyToken(token: token) { statusCode in
            // If token is verified
            if statusCode == 200 {
                DispatchQueue.main.async {
                    // Create Queue
                    let createQueueVC = CreateQueueViewController()
                    self.present(createQueueVC, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    // Authentication
                    let authVC = AuthViewController()
                    authVC.updateUIDelegate = self
                    self.present(authVC, animated: true)
                }
            }
        }
    }
}

// MARK: - UI
extension MainViewController {
    private func setupUI() {
        updateProfileButton()
        
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        navigationController?.navigationBar.addSubview(profileButton)
        view.addSubview(logoImageView)
        let buttonStackView = UIStackView(arrangedSubviews: [scanQrButton, findQueueButton, createQueueButton], axis: .vertical, spacing: 10)
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.setCustomSpacing(40, after: findQueueButton)
        buttonStackView.distribution = .fillEqually
        view.addSubview(buttonStackView)
        
        // Setup Profile Button
        profileButton.layer.cornerRadius = 45
        profileButton.clipsToBounds = true
        NSLayoutConstraint.activate([
            profileButton.topAnchor.constraint(equalTo: navigationController!.navigationBar.topAnchor, constant: 20),
            profileButton.trailingAnchor.constraint(equalTo: navigationController!.navigationBar.trailingAnchor, constant: -20),
            profileButton.heightAnchor.constraint(equalToConstant: 90),
            profileButton.widthAnchor.constraint(equalToConstant: 90)
        ])
        
        // Setup Logo Image View
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 0.3 * view.frame.size.height),
            logoImageView.widthAnchor.constraint(equalToConstant: 0.3 * view.frame.size.width)
        ])
        
        // Setup Button Stack View
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
        ])
    }
    
    public func updateProfileButton() {
        var image: UIImage
        // If user if logged
        if let user = SceneDelegate.user {
            guard let avatarData = user.avatarData else { return }
            guard let avatarImage = UIImage(data: avatarData) else { return }
            image = avatarImage
        } else {
            // Assign default image
            image = #imageLiteral(resourceName: "avatar")
        }
        profileButton.setBackgroundImage(image, for: .normal)
    }
}

// MARK: - UpdateUIDelegate
extension MainViewController: UpdateUIDelegate {
    func updateUI() {
        updateProfileButton()
    }
}

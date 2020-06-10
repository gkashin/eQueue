//
//  QRCodeViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 07.05.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import MessageUI
import UIKit

class QRCodeViewController: UIViewController {
    
    // MARK: Delegates
    weak var createQueueDelegate: CreateQueueDelegate?
    
    // MARK: Image Views
    let qrImageView = UIImageView()
    
    // MARK: Buttons
    let sendToEmailButton = UIButton(title: "Отправить на email", backgroundColor: .buttonDark(), titleColor: .white, font: .avenir20(), isShadow: false)
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    // MARK: Initializers
    init(qrWithText text: String) {
        super.init(nibName: nil, bundle: nil)
        
        guard let qr = generateQRCode(from: text) else { return }
        qrImageView.image = qr
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // Targets
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        sendToEmailButton.addTarget(self, action: #selector(sendToEmailButtonTapped), for: .touchUpInside)
    }
    
    func dismiss() {
        let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
        self.dismiss(animated: true, completion: nil)
        self.createQueueDelegate?.dismiss()
        tabBarController.selectedIndex = 2
    }
}

// MARK: - OBJC Methods
extension QRCodeViewController {
    // MARK: Button's Targets
    @objc private func closeButtonTapped() {
        self.dismiss()
    }
    
    @objc private func sendToEmailButtonTapped() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["\(SceneDelegate.user!.email!)"])
            mail.setSubject("QR_Code")
            
            guard let qrData = qrImageView.image!.pngData() else { return }
            mail.addAttachmentData(qrData, mimeType: "image/png", fileName: "QR_Code")
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
}

// MARK: - QR Methods
extension QRCodeViewController {
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}

// MARK: - UI
extension QRCodeViewController {
    private func setupUI() {
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        view.backgroundColor = .white
        qrImageView.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [qrImageView, sendToEmailButton], axis: .vertical, spacing: 20)
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: closeButton.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension QRCodeViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            self.dismiss()
        }
    }
}

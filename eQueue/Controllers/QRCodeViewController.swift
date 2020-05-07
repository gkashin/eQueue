//
//  QRCodeViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 07.05.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import MessageUI
import UIKit

class QRCodeViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    let qrImageView = UIImageView()
    let sendToEmailButton = UIButton(title: "Отправить на email", backgroundColor: .buttonDark(), titleColor: .white, font: .avenir20(), isShadow: false)
    
    init(qrWithText text: String) {
        super.init(nibName: nil, bundle: nil)
        
        guard let qr = generateQRCode(from: text) else { return }
        qrImageView.image = qr
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        sendToEmailButton.addTarget(self, action: #selector(sendToEmailButtonTapped), for: .touchUpInside)
    }
    
    @objc private func sendToEmailButtonTapped() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["georgii.kashin@gmail.com"])
            mail.setSubject("QR_Code")
            
            guard let qrData = qrImageView.image!.pngData() else { return }
            mail.addAttachmentData(qrData, mimeType: "image/png", fileName: "QR_Code")
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 7, y: 7)

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
        view.backgroundColor = .white
        qrImageView.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [qrImageView, sendToEmailButton], axis: .vertical, spacing: 20)
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
}

//
//  ScanQRViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 13.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import AVFoundation
import UIKit

class ScanQRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    // MARK: Stored Properties
    let session = AVCaptureSession()
    var video = AVCaptureVideoPreviewLayer()
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideo()
        startRunning()
    }
    
    // MARK: QR Methods
    func setupVideo() {
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
    }
    
    func startRunning() {
        view.layer.addSublayer(video)
        session.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0 else { return }
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if object.type == AVMetadataObject.ObjectType.qr {
                self.session.stopRunning()
                
                var queue: Queue!
                
                let notFoundAlert = createAlert(withTitle: "Очередь не обнаружена")
                
                // If qr code is not integer number
                guard let queueId = Int(object.stringValue!) else {
                    self.present(notFoundAlert, animated: true)
                    return
                }
                
                NetworkManager.shared.findQueue(id: queueId) { found in
                    // If queue doesn't found
                    guard let found = found else {
                        self.present(notFoundAlert, animated: true)
                        return
                    }
                    
                    queue = found
                    
                    guard queue?.ownerId != SceneDelegate.user?.id else {
                        // If found queue is own created queue
                        DispatchQueue.main.async {
                            let infoAlert = self.createAlert(withTitle: "Вы не можете встать в свою очередь")
                            
                            self.present(infoAlert, animated: true)
                        }
                        return
                    }
                    
                    // If all is OK
                    if queue != nil {
                        let enterAlert = self.createEnterAlert(with: queue)
                        
                        DispatchQueue.main.async {
                            self.present(enterAlert, animated: true, completion: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.present(notFoundAlert, animated: true)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - UI
extension ScanQRViewController {
    private func createAlert(withTitle title: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.session.startRunning()
        }
        alert.addAction(okAction)
        
        return alert
    }
    
    private func createEnterAlert(with queue: Queue) -> UIAlertController {
        let enterAlert = UIAlertController(title: "\(queue.name)", message: queue.description, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel) { _ in
            self.session.startRunning()
        }
        enterAlert.addAction(cancelAction)
        
        enterAlert.addAction(UIAlertAction(title: "Встать в очередь", style: .default, handler: { _ in
            NetworkManager.shared.enterQueue(id: queue.id) { found in
                guard let found = found else { return }
                
                var tabBarController: UITabBarController?
                DispatchQueue.main.async {
                    tabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
                }
                
                var index: Int!
                if found.status == "upcoming" {
                    index = 2
                } else if found.status == "active" {
                    DispatchQueue.main.async {
                        self.view.layer.sublayers?.removeLast()
                    }
                    index = 1
                }
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    tabBarController?.selectedIndex = index
                }
            }
        }))
        
        return enterAlert
    }
}

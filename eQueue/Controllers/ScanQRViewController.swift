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
    
    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideo()
        startRunning()
    }
    
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
                let notFoundAlert = UIAlertController(title: "Очередь не обнаружена", message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self.session.startRunning()
                }
                notFoundAlert.addAction(okAction)
                
                guard let queueId = Int(object.stringValue!) else {
                    self.present(notFoundAlert, animated: true)
                    return
                }
                
                NetworkManager.shared.findQueue(id: queueId) { found in
                    queue = found
                    
                    if queue != nil {
                        let enterAlert = UIAlertController(title: "Обнаружена очередь", message: object.stringValue, preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel) { _ in
                            self.session.startRunning()
                        }
                        enterAlert.addAction(cancelAction)
                        
                        enterAlert.addAction(UIAlertAction(title: "Встать в очередь", style: .default, handler: { _ in
                            NetworkManager.shared.enterQueue(id: queueId) { found in
                                guard let found = found else { return }
                                queue = found
                                
                                queue.people = [User()]
                                queue.startDate = Date()
                                queue.description = ""
                                queue.isCompleted = false
                                
                                queue.people.append(User(username: "Егор2", password: "pass", email: "email2", firstName: "Dmitry", lastName: "Chuchin"))
                                queue.people.append(User(username: "Егор1", password: "pass", email: "email1", firstName: "Ivan", lastName: "Kuznetsov"))
                                queue.people.append(User(username: "Егор", password: "pass", email: "email", firstName: "George", lastName: "Kashin"))
                                
                                var tabBarController: UITabBarController?
                                DispatchQueue.main.async {
                                    tabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
                                }
                                
                                let index: Int
                                if queue.startDate > Date() {
                                    ControlViewController.upcomingQueues.append(queue)
    
                                    index = 2
                                } else {
                                    QueueViewController.currentQueue = queue
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

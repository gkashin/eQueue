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
                
                let alert = UIAlertController(title: "Обнаружена очередь", message: object.stringValue, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Отменить", style: .cancel) { _ in
                    self.session.startRunning()
                }
                alert.addAction(cancelAction)
                
                alert.addAction(UIAlertAction(title: "Встать в очередь", style: .default, handler: { _ in
                    var queue = Queue(name: object.stringValue!, description: "", startDate: Date(), people: [], isOwnCreated: false)
                    
                    queue.people.append(User(username: "Егор2", password: "pass", email: "email2", firstName: "Dmitry", lastName: "Chuchin"))
                    queue.people.append(User(username: "Егор1", password: "pass", email: "email1", firstName: "Ivan", lastName: "Kuznetsov"))
                    queue.people.append(User(username: "Егор", password: "pass", email: "email", firstName: "George", lastName: "Kashin"))
                    
                    QueueViewController.currentQueue = queue
                    self.view.layer.sublayers?.removeLast()
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
                    tabBarController?.selectedIndex = 1
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }
}

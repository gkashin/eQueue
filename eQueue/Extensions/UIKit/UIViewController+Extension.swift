//
//  UIViewController+Extension.swift
//  eQueue
//
//  Created by Георгий Кашин on 25.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

var vSpinner : UIView?

extension UIViewController {
    func createAlert(withTitle title: String, andMessage message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
//        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        let okAction = UIAlertAction(title: "ОК", style: .default)
        
//        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        return alertController
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
//        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}

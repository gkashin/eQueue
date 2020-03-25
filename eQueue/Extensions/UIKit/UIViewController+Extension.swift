//
//  UIViewController+Extension.swift
//  eQueue
//
//  Created by Георгий Кашин on 25.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

extension UIViewController {
    func createAlert(withTitle title: String, andMessage message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
//        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        let okAction = UIAlertAction(title: "ОК", style: .default)
        
//        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        return alertController
    }
}

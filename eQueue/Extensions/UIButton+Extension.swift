//
//  UIButton+Extension.swift
//  eQueue
//
//  Created by Георгий Кашин on 04.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(title: String,
                     backgroundColor: UIColor,
                     titleColor: UIColor,
                     font: UIFont? = .avenir20(),
                     isShadow: Bool,
                     cornerRadius: CGFloat = 4
    ) {
        self.init(type: .system)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
        
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
    }
    
    func customizeGoogleButton() {
        let googleLogo = UIImageView(image: #imageLiteral(resourceName: "googleLogo"), contentMode: .scaleAspectFit)
        googleLogo.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(googleLogo)
        
        googleLogo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24).isActive = true
        googleLogo.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}


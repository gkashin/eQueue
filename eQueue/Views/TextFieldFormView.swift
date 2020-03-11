//
//  TextFieldFormView.swift
//  eQueue
//
//  Created by Георгий Кашин on 11.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class TextFieldFormView: UIView {
    init(label: UILabel, textField: OneLineTextField) {
        super.init(frame: .zero)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(label)
        self.addSubview(textField)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textField.widthAnchor.constraint(equalToConstant: 100)
        ])
        
//        bottomAnchor.constraint(equalTo: textField.bottomAnchor).isActive = true
        heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

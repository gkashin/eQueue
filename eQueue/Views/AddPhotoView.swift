//
//  AddPhotoView.swift
//  eQueue
//
//  Created by Георгий Кашин on 08.04.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class AddPhotoView: UIView {
    
    let circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "avatar")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        
        return imageView
    }()
    
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = #imageLiteral(resourceName: "plus")
        button.setImage(image, for: .normal)
        button.tintColor = .buttonDark()
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(circleImageView)
        addSubview(plusButton)
        
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleImageView.layer.masksToBounds = true
        circleImageView.layer.cornerRadius = circleImageView.frame.width * 0.5
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            circleImageView.topAnchor.constraint(equalTo: topAnchor),
            circleImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            circleImageView.widthAnchor.constraint(equalToConstant: 100),
            circleImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            plusButton.leadingAnchor.constraint(equalTo: circleImageView.trailingAnchor, constant: 16),
            plusButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        bottomAnchor.constraint(equalTo: circleImageView.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: plusButton.trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


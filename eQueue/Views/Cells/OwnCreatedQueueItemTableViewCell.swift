//
//  OwnCreatedQueueItemTableViewCell.swift
//  eQueue
//
//  Created by Георгий Кашин on 10.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class OwnCreatedQueueItemTableViewCell: UITableViewCell {
    
    static let id = "secondQueueItemCellId"
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 1, green: 0.7843137255, blue: 0.1725490196, alpha: 1)
        label.text = "0"
        label.textAlignment = .center
        label.font = .avenir20()
        label.font = label.font.withSize(15)
        label.widthAnchor.constraint(equalToConstant: 40).isActive = true
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        
        return label
    }()
    
    let fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Full name"
        return label
    }()
    
    let extraInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Extra info"
        return label
    }()
    
    let removePersonButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "remove"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension OwnCreatedQueueItemTableViewCell {
    private func setupConstraints() {
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(numberLabel)
        
        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [fullNameLabel, extraInfoLabel], axis: .vertical, spacing: 10)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 20),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(removePersonButton)
        removePersonButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            removePersonButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            removePersonButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            removePersonButton.widthAnchor.constraint(equalToConstant: 40),
            removePersonButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

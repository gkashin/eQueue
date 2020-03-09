//
//  QueueItemTableViewCell.swift
//  eQueue
//
//  Created by Георгий Кашин on 09.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class QueueItemTableViewCell: UITableViewCell {
    
    static let id = "queueItemCellId"
    
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
    
    let offerExchangeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "exchange"), for: .normal)
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
extension QueueItemTableViewCell {
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
        
        addSubview(offerExchangeButton)
        offerExchangeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            offerExchangeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            offerExchangeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            offerExchangeButton.widthAnchor.constraint(equalToConstant: 40),
            offerExchangeButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

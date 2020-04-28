//
//  QueueTableViewCell.swift
//  eQueue
//
//  Created by Георгий Кашин on 10.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class QueueTableViewCell: UITableViewCell {
    
    static let id = "queueCellId"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Зачет по алгоритмам"
        return label
    }()
    
    let extraInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "3530202/80001"
        return label
    }()
    
    let peopleCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Участники: 1024"
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "01.01.2020"
        label.numberOfLines = 2
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: 20, y: frame.size.height / 2 - 20, width: 40, height: 40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension QueueTableViewCell {
    private func setupConstraints() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, extraInfoLabel, peopleCountLabel], axis: .vertical, spacing: 10)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setCustomSpacing(15, after: extraInfoLabel)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.imageView!.trailingAnchor, constant: 10),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func setupUI(with queue: Queue) {
        nameLabel.text = queue.name
        extraInfoLabel.text = queue.description
        peopleCountLabel.text = "Участники: \(String(describing: queue.people?.count))"
        
        let dateFormatter = DateFormatter()
        let dateTime = queue.startDate.split(separator: " ")
        dateLabel.text = "\(dateTime.first!)\n\(dateTime.last!)"
        
        imageView?.image = queue.ownerId == SceneDelegate.user?.id ? #imageLiteral(resourceName: "crown") : #imageLiteral(resourceName: "circle")
    }
}

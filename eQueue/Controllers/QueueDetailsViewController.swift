//
//  QueueDetailsViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 09.04.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class QueueDetailsViewController: UIViewController {
    
    let nameLabel = UILabel(text: "Название")
    let descriptionLabel = UILabel(text: "Описание")
    let startDateLabel = UILabel(text: "Дата")
    let nameTextField = OneLineTextField(font: .avenir20())
    let descriptionTextField = OneLineTextField(font: .avenir20())
    let startDateTextField = OneLineTextField(font: .avenir20())
    
    var queue = Queue()
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    
        title = queue.name
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
        
        tableView = UITableView()
        let cellType = queue.isOwnCreated ? OwnCreatedQueueItemTableViewCell.self : QueueItemTableViewCell.self
        let cellId = queue.isOwnCreated ? OwnCreatedQueueItemTableViewCell.id : QueueItemTableViewCell.id
        tableView.register(cellType, forCellReuseIdentifier: cellId)
        
        setupUI()
    
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UI
extension QueueDetailsViewController {
    private func setupUI() {
        nameTextField.text = queue.name
        descriptionTextField.text = queue.description
        startDateTextField.text = DateFormatter().getString(from: queue.startDate)
        
        let nameTextFieldFormView = TextFieldFormView(label: nameLabel, textField: nameTextField)
        let descriptionTextFieldFormView = TextFieldFormView(label: descriptionLabel, textField: descriptionTextField)
        let startDateTextFieldFormView = TextFieldFormView(label: startDateLabel, textField: startDateTextField)
        
        let stackView = UIStackView(arrangedSubviews: [nameTextFieldFormView, descriptionTextFieldFormView, startDateTextFieldFormView], axis: .vertical, spacing: 10)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 700),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40),
            
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 100),
        ])
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension QueueDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Участники"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queue.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = queue.isOwnCreated ? OwnCreatedQueueItemTableViewCell.id : QueueItemTableViewCell.id
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        var user = User()
        
        user = queue.people[indexPath.row]
        
        if queue.isOwnCreated {
            let ownCreatedQueueItemTableViewCell = cell as! OwnCreatedQueueItemTableViewCell
            ownCreatedQueueItemTableViewCell.setup(with: user, at: indexPath)
        } else {
            let queueItemTableViewCell = cell as! QueueItemTableViewCell
            queueItemTableViewCell.setup(with: user, at: indexPath, isLast: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        guard QueueViewController.currentQueue != nil else { return .none }
        
        if QueueViewController.currentQueue!.isOwnCreated {
            return .delete
        } else {
            return .none
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            queue.people.remove(at: indexPath.row)
            tableView.reloadData()
        case .insert:
            break
        case .none:
            break
        @unknown default:
            print("New editing styles had appeared")
        }
    }
}

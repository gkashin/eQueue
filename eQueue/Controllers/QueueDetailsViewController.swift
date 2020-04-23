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
    
    let actionButton = UIButton(title: "Повторить", backgroundColor: .buttonDark(), titleColor: .white, font: .avenir20(), isShadow: false)
    
    let removeButton = UIButton()
    
    var queue = Queue()
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        title = queue.name
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
        
        tableView = UITableView()
        let cellType = queue.ownerId == SceneDelegate.user?.id ? OwnCreatedQueueItemTableViewCell.self : QueueItemTableViewCell.self
        let cellId = queue.ownerId == SceneDelegate.user?.id ? OwnCreatedQueueItemTableViewCell.id : QueueItemTableViewCell.id
        tableView.register(cellType, forCellReuseIdentifier: cellId)
        
        setupUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func actionButtonTapped() {
        var createQueueVC: CreateQueueViewController
        var action = ""
        if queue.ownerId == SceneDelegate.user?.id {
            if queue.status == "upcoming" {
                // Change
                action = "Изменить"
            } else if queue.status == "completed" {
                // Start again
                action = "Повторить"
            }
        } else {
            if queue.status == "upcoming" {
                // Leave
                let index = ControlViewController.upcomingQueues.firstIndex(where: { $0.id == queue.id })!
                ControlViewController.upcomingQueues.remove(at: index)
                navigationController?.popToRootViewController(animated: true)
                return
            } else if queue.status == "completed" {
                // Delete
                let index = ControlViewController.completedQueues.firstIndex(where: { $0.id == queue.id })!
                ControlViewController.completedQueues.remove(at: index)
                navigationController?.popToRootViewController(animated: true)
            }
        }
        createQueueVC = CreateQueueViewController(queue: queue, action: action)
        createQueueVC.completionHandler = { queue in
            self.queue = queue
            self.updateUI()
        }
        present(createQueueVC, animated: true)
    }
    
    @objc private func removeButtonTapped() {
        let index = ControlViewController.upcomingQueues.firstIndex(where: { $0.id == queue.id })!
        ControlViewController.upcomingQueues.remove(at: index)
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - UI
extension QueueDetailsViewController {
    private func setupUI() {
        updateUI()
        setTextFields(enabled: false)
        
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
        
        setupActionButton()
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80),
            
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -80),
            tableView.heightAnchor.constraint(equalToConstant: 340)
        ])
        
        scrollView.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            actionButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 200),
        ])
        
        if queue.ownerId == SceneDelegate.user?.id && queue.status == "upcoming" {
            view.addSubview(removeButton)
            
            removeButton.translatesAutoresizingMaskIntoConstraints = false
            removeButton.setBackgroundImage(UIImage(systemName: "bin.xmark"), for: .normal)
            
            NSLayoutConstraint.activate([
                actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -20),
                
                removeButton.bottomAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 5),
                removeButton.leadingAnchor.constraint(equalTo: actionButton.trailingAnchor, constant: 30),
                removeButton.widthAnchor.constraint(equalToConstant: 50),
                removeButton.heightAnchor.constraint(equalToConstant: 50),
            ])
        }
    }
    
    
    private func updateUI() {
        nameTextField.text = queue.name
        descriptionTextField.text = queue.description
        startDateTextField.text = DateFormatter().getString(from: queue.startDate ?? Date())
    }
    
    private func setupActionButton() {
        var buttonTitle = ""
        if queue.ownerId == SceneDelegate.user?.id {
            if queue.status == "upcoming" {
                buttonTitle = "Изменить"
            } else if queue.status == "completed" {
                buttonTitle = "Повторить"
            }
        } else {
            if queue.status == "upcoming" {
                buttonTitle = "Покинуть"
            } else if queue.status == "completed" {
                buttonTitle = "Удалить"
            }
        }
        actionButton.setTitle(buttonTitle, for: .normal)
    }
    
    private func setTextFields(enabled: Bool) {
        nameTextField.isEnabled = enabled
        descriptionTextField.isEnabled = enabled
        startDateTextField.isEnabled = enabled
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension QueueDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Участники"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queue.people?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = queue.ownerId == SceneDelegate.user?.id ? OwnCreatedQueueItemTableViewCell.id : QueueItemTableViewCell.id
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        var user = User()
        
        user = queue.people[indexPath.row]
        
        if queue.ownerId == SceneDelegate.user?.id {
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
        
        if QueueViewController.currentQueue!.ownerId == SceneDelegate.user?.id {
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

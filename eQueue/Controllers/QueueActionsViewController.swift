//
//  QueueDetailViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 24.04.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class QueueActionsViewController: UIViewController {
    
    let queue: Queue!
    var tableView: UITableView!
    
    let hideButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "hide"), for: .normal)
        return button
    }()
    
    let nameLabel = UILabel(text: "Название", font: .avenir20())
    let descriptionLabel = UILabel(text: "Описание", font: .avenir20())
    let startDateLabel = UILabel(text: "Дата", font: .avenir20())
    let peopleCountLabel = UILabel(text: "Участников", font: .avenir20())
    
    let actionButton = UIButton(title: "Начать", backgroundColor: .buttonDark(), titleColor: .white, isShadow: false)
    let changeButton = UIButton(title: "Изменить", backgroundColor: .white, titleColor: .darkText, font: .avenir16(), isShadow: true)
    let showPeopleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Показать участников", for: .normal)
        button.setTitleColor(.darkText, for: .normal)
        return button
    }()
    let removeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "bin"), for: .normal)
        return button
    }()
    
    init(queue: Queue) {
        self.queue = queue
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        
        tableView = UITableView()
        let cellType = queue.ownerId == SceneDelegate.user?.id ? OwnCreatedQueueItemTableViewCell.self : QueueItemTableViewCell.self
        let cellId = queue.ownerId == SceneDelegate.user?.id ? OwnCreatedQueueItemTableViewCell.id : QueueItemTableViewCell.id
        tableView.register(cellType, forCellReuseIdentifier: cellId)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupUI()
        hideButton.addTarget(self, action: #selector(hideButtonTapped), for: .touchUpInside)
        showPeopleButton.addTarget(self, action: #selector(showPeopleButtonTapped), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    @objc private func hideButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func showPeopleButtonTapped() {
        view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            view.heightAnchor.constraint(equalToConstant: 500)
//        ])
        
    }
    
    @objc private func actionButtonTapped() {
        NetworkManager.shared.callNext(id: queue.id) { statusCode in
            guard statusCode == 204 else { return }
            
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    QueueViewController.currentQueue = self.queue
                    let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
                    tabBarController.selectedIndex = 1
                }
            }
        }
    }
}

// MARK: - UI
extension QueueActionsViewController {
    private func setupUI() {
        setupLabels()
        
        // Hide button
        hideButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hideButton)
        
        NSLayoutConstraint.activate([
            hideButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            hideButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Top stack view
        let topStackView = UIStackView(arrangedSubviews: [changeButton, removeButton], axis: .horizontal, spacing: 10)
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topStackView)
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        // Middle stack view
        let stackView = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel, startDateLabel, peopleCountLabel], axis: .vertical, spacing: 20)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
        ])
        
        // Show people button
        showPeopleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(showPeopleButton)
        
        NSLayoutConstraint.activate([
            showPeopleButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            showPeopleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        // Action button
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 200),
        ])
        
        // Table view
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(tableView)
//        
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -80),
//            tableView.heightAnchor.constraint(equalToConstant: 340)
//        ])
    }
    
    private func setupLabels() {
        nameLabel.text = queue.name
        descriptionLabel.text = queue.description
        startDateLabel.text = queue.startDate
        peopleCountLabel.text = "Участников: \(queue.queue.count ?? 10)"
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension QueueActionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Участники"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queue.queue.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = queue.ownerId == SceneDelegate.user?.id ? OwnCreatedQueueItemTableViewCell.id : QueueItemTableViewCell.id
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        var user = User()
        
        user = queue.queue[indexPath.row]
        
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
//            queue.people.remove(at: indexPath.row)
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

// MARK: - SwiftUI
import SwiftUI

struct QueueActionsVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let queueActionsVC = QueueActionsViewController(queue: Queue())

        func makeUIViewController(context: UIViewControllerRepresentableContext<QueueActionsVCProvider.ContainerView>) -> QueueActionsViewController  {
            return queueActionsVC
        }
        
        func updateUIViewController(_ uiViewController: QueueActionsVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<QueueActionsVCProvider.ContainerView>) {
            
        }
    }
}

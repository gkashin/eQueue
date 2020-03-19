//
//  QueueViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 09.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class QueueViewController: UIViewController {
    
    static var currentQueue: Queue?
    
    var tableView: UITableView!
    
    let lineNumberLabel = UILabel(text: "Вы 3-й в очереди!")
    let waitingTimeLabel = UILabel(text: "Среднее время ожидания: ∞")
    var queueInfoStackView: UIStackView!
    let quitQueueButton = UIButton(title: "Покинуть очередь", backgroundColor: .buttonDark(), titleColor: .white, isShadow: false)
    
    let totalPeopleLabel = UILabel(text: "Всего человек: 1024")
    let terminateQueueButton = UIButton(title: "Завершить очередь", backgroundColor: .buttonDark(), titleColor: .white, isShadow: false)
    
    let stubLabel = UILabel(text: "У вас нет текущей очереди")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView = UITableView(frame: CGRect(x: 0, y: 250, width: view.frame.size.width, height: view.frame.size.height), style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        let firstCellType = QueueItemTableViewCell.self
        let secondCellType = OwnCreatedQueueItemTableViewCell.self
        let firstId = QueueItemTableViewCell.id
        let secondId = OwnCreatedQueueItemTableViewCell.id
        tableView.register(firstCellType, forCellReuseIdentifier: firstId)
        tableView.register(secondCellType, forCellReuseIdentifier: secondId)
        
        view.addSubview(UIView(frame: .zero))
        view.addSubview(tableView)
        
        setupUI()
        
        terminateQueueButton.addTarget(self, action: #selector(terminateQueueButtonTapped), for: .touchUpInside)
        quitQueueButton.addTarget(self, action: #selector(quitQueueButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationItem.title = QueueViewController.currentQueue?.name ?? "Моя очередь"
        updateUI()
    }
    
    @objc private func terminateQueueButtonTapped() {
        ControlViewController.completedQueues.append(QueueViewController.currentQueue!)
        QueueViewController.currentQueue = nil
        updateUI()
    }
    
    @objc private func quitQueueButtonTapped() {
        ControlViewController.completedQueues.append(QueueViewController.currentQueue!)
        QueueViewController.currentQueue = nil
        updateUI()
    }
}

// MARK: - UI
extension QueueViewController {
    private func setupUI() {
        queueInfoStackView = UIStackView(arrangedSubviews: [lineNumberLabel, waitingTimeLabel], axis: .vertical, spacing: 10)
        queueInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        queueInfoStackView.alignment = .center
        
        view.addSubview(queueInfoStackView)
        NSLayoutConstraint.activate([
            queueInfoStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            queueInfoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        view.addSubview(totalPeopleLabel)
        view.addSubview(terminateQueueButton)
        totalPeopleLabel.translatesAutoresizingMaskIntoConstraints = false
        terminateQueueButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            totalPeopleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            totalPeopleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            terminateQueueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            terminateQueueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            terminateQueueButton.widthAnchor.constraint(equalToConstant: 200),
        ])
        
        quitQueueButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(quitQueueButton)
        NSLayoutConstraint.activate([
            quitQueueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            quitQueueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quitQueueButton.widthAnchor.constraint(equalToConstant: 200),
        ])
        
        view.addSubview(stubLabel)
        stubLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func updateUI() {
        tableView.reloadData()
        
        guard QueueViewController.currentQueue != nil else {
            navigationItem.title = "Моя очередь"
            stubLabel.isHidden = false
            hideAll()
            return
        }
        
        stubLabel.isHidden = true
        if QueueViewController.currentQueue!.isOwnCreated {
            queueInfoStackView.isHidden = true
            totalPeopleLabel.isHidden = false
            terminateQueueButton.isHidden = false
            quitQueueButton.isHidden = true
        } else {
            queueInfoStackView.isHidden = false
            totalPeopleLabel.isHidden = true
            terminateQueueButton.isHidden = true
            quitQueueButton.isHidden = false
        }
    }
    
    private func hideAll() {
        queueInfoStackView.isHidden = true
        totalPeopleLabel.isHidden = true
        terminateQueueButton.isHidden = true
        quitQueueButton.isHidden = true
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension QueueViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        currentQueue.people.count
        guard QueueViewController.currentQueue != nil else { return 0 }
        return /* currentQueue!.people.count */ 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard QueueViewController.currentQueue != nil else { return UITableViewCell() }
        
        let id = QueueViewController.currentQueue!.isOwnCreated ? OwnCreatedQueueItemTableViewCell.id : QueueItemTableViewCell.id
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard QueueViewController.currentQueue != nil else { return 0 }
        return QueueViewController.currentQueue!.isOwnCreated ? 80 : 120
    }
}

// MARK: - SwiftUI
import SwiftUI

struct QueueVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let tabBarVC = MainTabBarController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<QueueVCProvider.ContainerView>) -> MainTabBarController  {
            return tabBarVC
        }
        
        func updateUIViewController(_ uiViewController: QueueVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<QueueVCProvider.ContainerView>) {
            
        }
    }
}

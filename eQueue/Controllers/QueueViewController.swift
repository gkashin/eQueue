//
//  QueueViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 09.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class QueueViewController: UIViewController {
    
    var currentQueue: Queue? = Queue() {
        didSet {
            updateUI()
        }
    }
    var tableView: UITableView!
    
    let lineNumberLabel = UILabel(text: "Вы 3-й в очереди!")
    let waitingTimeLabel = UILabel(text: "Среднее время ожидания: ∞")
    var queueInfoStackView: UIStackView!
    
    let totalPeopleLabel = UILabel(text: "Всего человек: 1024")
    let removeQueueButton = UIButton(title: "Удалить очередь", backgroundColor: .buttonDark(), titleColor: .white, isShadow: false)
    
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
        updateUI()
        
        removeQueueButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: CreateQueueViewController.addQueueNotificationName, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationItem.title = currentQueue?.name ?? "Моя очередь"
    }
    
    @objc private func removeButtonTapped() {
        currentQueue = nil
        updateUI()
    }
    
    @objc private func getData(from notification: Notification) {
        currentQueue = notification.userInfo!["queue"] as? Queue
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
        view.addSubview(removeQueueButton)
        totalPeopleLabel.translatesAutoresizingMaskIntoConstraints = false
        removeQueueButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            totalPeopleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            totalPeopleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            removeQueueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            removeQueueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            removeQueueButton.widthAnchor.constraint(equalToConstant: 200),
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
        
        guard currentQueue != nil else {
            navigationItem.title = "Моя очередь"
            stubLabel.isHidden = false
            hideAll()
            return
        }
        
        stubLabel.isHidden = true
        if currentQueue!.isOwnCreated {
            queueInfoStackView.isHidden = true
            totalPeopleLabel.isHidden = false
            removeQueueButton.isHidden = false
        } else {
            queueInfoStackView.isHidden = false
            totalPeopleLabel.isHidden = true
            removeQueueButton.isHidden = true
        }
    }
    
    private func hideAll() {
        queueInfoStackView.isHidden = true
        totalPeopleLabel.isHidden = true
        removeQueueButton.isHidden = true
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension QueueViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        currentQueue.people.count
        guard currentQueue != nil else { return 0 }
        return /* currentQueue!.people.count */ 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard currentQueue != nil else { return UITableViewCell() }
        
        let id = currentQueue!.isOwnCreated ? OwnCreatedQueueItemTableViewCell.id : QueueItemTableViewCell.id
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard currentQueue != nil else { return 0 }
        return currentQueue!.isOwnCreated ? 80 : 120
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

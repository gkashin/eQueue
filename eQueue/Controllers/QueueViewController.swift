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
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        tableView = UITableView(frame: CGRect(x: 0, y: 120, width: view.frame.size.width, height: view.frame.size.height), style: .insetGrouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        view.backgroundColor = tableView.backgroundColor
        
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
        updateTotalPeopleLabel()
        updateLineNumberLabel()
        
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
    
    private func updateTotalPeopleLabel() {
        if let peopleCount = QueueViewController.currentQueue?.people.count {
            totalPeopleLabel.text = "Всего человек: \(peopleCount)"
        }
    }
    
    private func updateLineNumberLabel() {
        if let peopleCount = QueueViewController.currentQueue?.people.count {
            lineNumberLabel.text = "Вы \(peopleCount) в очереди!"
        }
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
    func numberOfSections(in tableView: UITableView) -> Int {
        guard QueueViewController.currentQueue != nil else { return 1 }
        return QueueViewController.currentQueue!.isOwnCreated ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            guard QueueViewController.currentQueue != nil else { return "" }
            return QueueViewController.currentQueue!.isOwnCreated ? "Следующий" : ""
        case 1:
            return "Остальные"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard QueueViewController.currentQueue != nil else { return 0 }
        guard QueueViewController.currentQueue?.people.count != 0 else { return 0 }
        
        switch section {
        case 0:
            if QueueViewController.currentQueue!.isOwnCreated {
                return 1
            } else {
                return QueueViewController.currentQueue!.people.count
            }
        case 1:
            return QueueViewController.currentQueue!.people.count - 1
        default:
            return QueueViewController.currentQueue!.people.count - 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard QueueViewController.currentQueue != nil else { return UITableViewCell() }
        
        
        let id = QueueViewController.currentQueue!.isOwnCreated ? OwnCreatedQueueItemTableViewCell.id : QueueItemTableViewCell.id
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        var user = User()
        
        switch indexPath.section {
        case 0:
            if QueueViewController.currentQueue!.isOwnCreated {
                user = QueueViewController.currentQueue!.people.first!
            } else {
                user = QueueViewController.currentQueue!.people[indexPath.row]
            }
        case 1:
            user = QueueViewController.currentQueue!.people[indexPath.row + 1]
        default:
            break
        }
        
        if QueueViewController.currentQueue!.isOwnCreated {
            let ownCreatedQueueItemTableViewCell = cell as! OwnCreatedQueueItemTableViewCell
            ownCreatedQueueItemTableViewCell.setup(with: user, at: indexPath)
        } else {
            let queueItemTableViewCell = cell as! QueueItemTableViewCell
            let isLast = QueueViewController.currentQueue!.people.count - 1 == indexPath.row
            queueItemTableViewCell.setup(with: user, at: indexPath, isLast: isLast)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard QueueViewController.currentQueue != nil else { return 0 }
        return QueueViewController.currentQueue!.isOwnCreated ? 80 : 120
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
            QueueViewController.currentQueue?.people.remove(at: indexPath.row)
            updateTotalPeopleLabel()
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

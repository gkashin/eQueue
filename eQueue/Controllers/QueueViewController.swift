//
//  QueueViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 09.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class QueueViewController: UIViewController {
    
    let isOwnCreatedQueue = false
    
    let currentQueue = Queue()
    let lineNumberLabel = UILabel(text: "Вы 3-й в очереди!")
    let waitingTimeLabel = UILabel(text: "Среднее время ожидания: ∞")
    let removeQueueButton = UIButton(title: "Удалить очередь", backgroundColor: .buttonDark(), titleColor: .white, isShadow: false)
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.isHidden = true
        view.backgroundColor = .white
        title = currentQueue.name
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView = UITableView(frame: CGRect(x: 0, y: 250, width: view.frame.size.width, height: view.frame.size.height), style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let cellType = isOwnCreatedQueue ? OwnCreatedQueueItemTableViewCell.self : QueueItemTableViewCell.self
        let id = isOwnCreatedQueue ? OwnCreatedQueueItemTableViewCell.id : QueueItemTableViewCell.id
        tableView.register(cellType, forCellReuseIdentifier: id)
        
        view.addSubview(UIView(frame: .zero))
        view.addSubview(tableView)
        
        setupConstraints()
    }
}

// MARK: - Second View
extension QueueViewController {
    
}

// MARK: - UI
extension QueueViewController {
    private func setupConstraints() {
        if !isOwnCreatedQueue {
            let stackView = UIStackView(arrangedSubviews: [lineNumberLabel, waitingTimeLabel], axis: .vertical, spacing: 10)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.alignment = .center
            
            view.addSubview(stackView)
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])
        } else {
            view.addSubview(removeQueueButton)
            removeQueueButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                removeQueueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                removeQueueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension QueueViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        currentQueue.people.count
        return isOwnCreatedQueue ? 3 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = isOwnCreatedQueue ? OwnCreatedQueueItemTableViewCell.id : QueueItemTableViewCell.id
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isOwnCreatedQueue ? 80 : 120
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

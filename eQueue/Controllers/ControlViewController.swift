//
//  ControlViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 09.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class ControlViewController: UIViewController {
    
    var queues = [Queue()]
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Управление"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(QueueTableViewCell.self, forCellReuseIdentifier: QueueTableViewCell.id)
        
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addQueue), name: CreateQueueViewController.addQueueNotificationName, object: nil)
    }
    
    @objc private func addQueue(from notification: Notification) {
        guard let queue = notification.userInfo!["queue"] as? Queue else { return }
        queues.append(queue)
        
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ControlViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Предстоящие"
        case 1:
            return "Завершенные"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return queues.map { $0.startDate > Date() }.count
        case 1:
            return queues.map { $0.startDate < Date() }.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QueueTableViewCell.id, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: - SwiftUI
import SwiftUI

struct ControlVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let tabBarVC = MainTabBarController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<ControlVCProvider.ContainerView>) -> MainTabBarController  {
            return tabBarVC
        }
        
        func updateUIViewController(_ uiViewController: ControlVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ControlVCProvider.ContainerView>) {
            
        }
    }
}

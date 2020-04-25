//
//  ControlViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 09.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class ControlViewController: UIViewController {
    
    static var upcomingQueues = [Queue]()
    static var completedQueues = [Queue]()
    
    private let transition = PanelTransition()
    private lazy var popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Управление"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), style: .insetGrouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(QueueTableViewCell.self, forCellReuseIdentifier: QueueTableViewCell.id)
        
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard SceneDelegate.user != nil else {
            ControlViewController.upcomingQueues = []
            ControlViewController.completedQueues = []
            tableView.reloadData()
            return
        }
        
        NetworkManager.shared.myQueues { queues in
            guard let queues = queues else {
                ControlViewController.upcomingQueues = []
                ControlViewController.completedQueues = []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return
            }
            ControlViewController.upcomingQueues = queues.filter({ $0.status == "upcoming" })
            ControlViewController.completedQueues = queues.filter({ $0.status == "completed" })
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func popupViewlayout() {
        popupView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(popupView)
        popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        popupView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        popupView.heightAnchor.constraint(equalToConstant: 0.5 * view.frame.width).isActive = true
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
            return ControlViewController.upcomingQueues.count
        case 1:
            return ControlViewController.completedQueues.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var queue: Queue!
        
        switch indexPath.section {
        case 0:
            queue = ControlViewController.upcomingQueues[indexPath.row]
        case 1:
            queue = ControlViewController.completedQueues[indexPath.row]
        default:
            break
        }
        
        // ========================
        let queueActionsVC = QueueActionsViewController(queue: queue)
        queueActionsVC.transitioningDelegate = transition
        queueActionsVC.modalPresentationStyle = .custom

        present(queueActionsVC, animated: true)
            
//        popupViewlayout()
        
        
//        let queueDetailsVC = QueueDetailsViewController()
//        queueDetailsVC.queue = queue
//        navigationController?.pushViewController(queueDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QueueTableViewCell.id, for: indexPath) as! QueueTableViewCell
        
        switch indexPath.section {
        case 0:
            cell.setupUI(with: ControlViewController.upcomingQueues[indexPath.row])
        case 1:
            cell.setupUI(with: ControlViewController.completedQueues[indexPath.row])
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            ControlViewController.completedQueues.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
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

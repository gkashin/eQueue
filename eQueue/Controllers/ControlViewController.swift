//
//  ControlViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 09.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class ControlViewController: UIViewController {
    
    // MARK: Static Properties
    static var upcomingQueues = [Queue]()
    static var completedQueues = [Queue]()
    
    
    // MARK: - Properties
    private var transition: PanelTransition!
    
    
    // MARK: TableView
    var tableView: UITableView!
    
    
    // MARK: Buttons
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = .avenir20()
        return button
    }()
    
    
    // MARK: Labels
    let notAuthorizedStubLabel: UILabel = {
        let label = UILabel(text: "Вы не авторизованы.\nВойдите, чтобы продолжить работу")
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    
    // MARK: StackViews
    var notAuthorizedStackView: UIStackView!
    
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // Targets
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        updateUI()
    }
}

// MARK: - OBJC Methods
extension ControlViewController {
    // MARK: Button's Targets
    @objc private func loginButtonTapped() {
        let authVC = AuthViewController()
        authVC.updateUIDelegate = self
        self.present(authVC, animated: true)
    }
}

// MARK: - UI, ControlQueueDelegate
extension ControlViewController: ControlQueueDelegate {
    func setupUI() {
        setupTableView()
        addSubviews()
        
        view.backgroundColor = .white
        title = "Управление"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        notAuthorizedStackView = UIStackView(arrangedSubviews: [notAuthorizedStubLabel, loginButton], axis: .vertical, spacing: 20)
        view.addSubview(notAuthorizedStackView)
        notAuthorizedStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            notAuthorizedStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notAuthorizedStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), style: .insetGrouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(QueueTableViewCell.self, forCellReuseIdentifier: QueueTableViewCell.id)
        
        tableView.tableFooterView = UIView()
    }
    
    func hideAll() {
        notAuthorizedStackView.isHidden = true
        tableView.isHidden = true
    }
}

// MARK: - UpdateUIDelegate
extension ControlViewController: UpdateUIDelegate {
    func updateUI() {
        hideAll()
        showSpinner(onView: view)
        
        let token = SceneDelegate.defaults.object(forKey: "token") as? String ?? ""
        
        NetworkManager.shared.verifyToken(token: token) { statusCode in
            if statusCode == 200 {
                DispatchQueue.main.async {
                    var allQueues = [Queue]()
                    
                    NetworkManager.shared.myQueues { queues in
                        if queues != nil {
                            allQueues.append(contentsOf: queues!)
                        }
                        
                        NetworkManager.shared.myQueuesOwner { queues in
                            if queues != nil {
                                allQueues.append(contentsOf: queues!)
                            }
                            
                            if !allQueues.isEmpty {
                                ControlViewController.upcomingQueues = allQueues.filter({ $0.status == "upcoming" })
                                ControlViewController.completedQueues = allQueues.filter({ $0.status == "past" })
                            } else {
                                ControlViewController.upcomingQueues = []
                                ControlViewController.completedQueues = []
                            }
                            
                            DispatchQueue.main.async {
                                self.tableView.isHidden = false
                                self.notAuthorizedStackView.isHidden = true
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.notAuthorizedStackView.isHidden = false
                }
            }
            
            self.removeSpinner()
        }
    }
}

// MARK: - UITableViewDelegate
extension ControlViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        let queueActionsVC = QueueActionsViewController(queue: queue, controlQueueDelegate: self, selectedRow: tableView.indexPathForSelectedRow!.row)
        tableView.deselectRow(at: indexPath, animated: true)
        
        transition = PanelTransition(from: self, to: queueActionsVC)
        
        queueActionsVC.transitioningDelegate = transition
        queueActionsVC.modalPresentationStyle = .custom
        
        present(queueActionsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: - UITableViewDataSource
extension ControlViewController: UITableViewDataSource {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
}

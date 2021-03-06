//
//  QueueViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 09.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class QueueViewController: UIViewController {
    
    // MARK: Static Properties
    static var currentQueue: Queue?
    
    // MARK: - Properties
    
    // MARK: TableView
    var tableView: UITableView!
    
    
    // MARK: StackViews
    var queueInfoStackView: UIStackView!
    var notAuthorizedStackView: UIStackView!
    
    
    // MARK: Labels
    let lineNumberLabel = UILabel(text: "Вы 3-й в очереди!")
    let waitingTimeLabel = UILabel(text: "Среднее время ожидания: ∞")
    let totalPeopleLabel = UILabel(text: "Всего человек: 1024")
    let emptyQueueStubLabel = UILabel(text: "У вас нет текущей очереди")
    
    let notAuthorizedStubLabel: UILabel = {
        let label = UILabel(text: "Вы не авторизованы.\nВойдите, чтобы продолжить работу")
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    
    // MARK: Buttons
    let terminateQueueButton = UIButton(title: "Завершить очередь", backgroundColor: .buttonDark(), titleColor: .white, isShadow: false)
    let quitQueueButton = UIButton(title: "Покинуть очередь", backgroundColor: .buttonDark(), titleColor: .white, isShadow: false)
    let callNextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(#imageLiteral(resourceName: "next"), for: .normal)
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = .avenir20()
        return button
    }()
    
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // Targets
        terminateQueueButton.addTarget(self, action: #selector(terminateQueueButtonTapped), for: .touchUpInside)
        quitQueueButton.addTarget(self, action: #selector(quitQueueButtonTapped), for: .touchUpInside)
        callNextButton.addTarget(self, action: #selector(callNextButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.updateUI()
    }
}

// MARK: - OBJC Methods
extension QueueViewController {
    // MARK: Button's Targets
    @objc private func terminateQueueButtonTapped() {
        NetworkManager.shared.finishQueue(id: QueueViewController.currentQueue!.id) { statusCode in
            guard statusCode == 204 else { return }
            
            QueueViewController.currentQueue = nil
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    @objc private func quitQueueButtonTapped() {
        NetworkManager.shared.leaveQueue(id: QueueViewController.currentQueue!.id) { statusCode in
            guard statusCode == 204 else { return }
            
            QueueViewController.currentQueue = nil
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    @objc private func callNextButtonTapped() {
        NetworkManager.shared.callNext(id: QueueViewController.currentQueue!.id) { statusCode in
            guard statusCode == 200 || statusCode == 204 else { return }
            
            // TODO: Handle empty queue situation
            //            QueueViewController.currentQueue?.queue.removeFirst()
            
            NetworkManager.shared.getCurrentOwnerQueue { queue in
                guard let queue = queue else { return }
                QueueViewController.currentQueue = queue.first
                
                DispatchQueue.main.async {
                    self.updateTotalPeopleLabel()
                    
                    if QueueViewController.currentQueue!.queue.isEmpty {
                        self.callNextButton.isHidden = true
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc private func loginButtonTapped() {
        let authVC = AuthViewController()
        authVC.updateUIDelegate = self
        self.present(authVC, animated: true)
    }
}

// MARK: - UI
extension QueueViewController {
    private func setupUI() {
        addSubviews()
        setupTableView()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = tableView.backgroundColor
        
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
        view.addSubview(callNextButton)
        totalPeopleLabel.translatesAutoresizingMaskIntoConstraints = false
        terminateQueueButton.translatesAutoresizingMaskIntoConstraints = false
        callNextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            totalPeopleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            totalPeopleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            terminateQueueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            terminateQueueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            terminateQueueButton.widthAnchor.constraint(equalToConstant: 220),
        ])
        
        NSLayoutConstraint.activate([
            callNextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            callNextButton.bottomAnchor.constraint(equalTo: terminateQueueButton.topAnchor, constant: -20),
            callNextButton.widthAnchor.constraint(equalToConstant: 60),
            callNextButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        quitQueueButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(quitQueueButton)
        NSLayoutConstraint.activate([
            quitQueueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            quitQueueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quitQueueButton.widthAnchor.constraint(equalToConstant: 200),
        ])
        
        view.addSubview(emptyQueueStubLabel)
        emptyQueueStubLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyQueueStubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyQueueStubLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        notAuthorizedStackView = UIStackView(arrangedSubviews: [notAuthorizedStubLabel, loginButton], axis: .vertical, spacing: 20)
        view.addSubview(notAuthorizedStackView)
        notAuthorizedStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            notAuthorizedStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notAuthorizedStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func addSubviews() {
        view.addSubview(UIView(frame: .zero))
        view.addSubview(tableView)
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 120, width: view.frame.size.width, height: view.frame.size.height - 120), style: .insetGrouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        // Register Cells
        let firstCellType = QueueItemTableViewCell.self
        let secondCellType = OwnCreatedQueueItemTableViewCell.self
        let firstId = QueueItemTableViewCell.id
        let secondId = OwnCreatedQueueItemTableViewCell.id
        
        tableView.register(firstCellType, forCellReuseIdentifier: firstId)
        tableView.register(secondCellType, forCellReuseIdentifier: secondId)
    }
    
    private func updateTotalPeopleLabel() {
        if let peopleCount = QueueViewController.currentQueue?.queue.count {
            self.totalPeopleLabel.text = "Всего человек: \(peopleCount)"
        }
    }
    
    private func updateLineNumberLabel() {
        if let peopleCount = QueueViewController.currentQueue?.queue.count {
            lineNumberLabel.text = "Вы \(peopleCount) в очереди!"
        }
    }
    
    private func hideAll() {
        queueInfoStackView.isHidden = true
        totalPeopleLabel.isHidden = true
        quitQueueButton.isHidden = true
        
        terminateQueueButton.isHidden = true
        callNextButton.isHidden = true
        
        notAuthorizedStackView.isHidden = true
        emptyQueueStubLabel.isHidden = true
        
        tableView.isHidden = true
    }
}

// MARK: - UpdateUIDelegate
extension QueueViewController: UpdateUIDelegate {
    func updateUI() {
        self.navigationItem.title = QueueViewController.currentQueue?.name ?? "Моя очередь"
        
        hideAll()
        showSpinner(onView: view)
        
        let token = SceneDelegate.defaults.object(forKey: "token") as? String ?? ""
        
        NetworkManager.shared.verifyToken(token: token) { statusCode in
            if statusCode == 200 {
                
                // ---------------------------
                // Get current NOT OWNER queue
                NetworkManager.shared.getCurrentQueue { queue in
                    guard let queue = queue else {
                        
                        // If not found, try to find current OWNER queue
                        NetworkManager.shared.getCurrentOwnerQueue { queue in
                            guard let queue = queue else {
                                DispatchQueue.main.async {
                                    self.navigationItem.title = "Моя очередь"
                                    self.emptyQueueStubLabel.isHidden = false
                                }
                                self.removeSpinner()
                                return
                            }
                            
                            QueueViewController.currentQueue = queue.first!
                            
                            DispatchQueue.main.async {
                                self.navigationItem.title = QueueViewController.currentQueue?.name
                                
                                self.notAuthorizedStackView.isHidden = true
                                self.emptyQueueStubLabel.isHidden = true
                                self.tableView.isHidden = false
                                
                                self.totalPeopleLabel.isHidden = false
                                self.terminateQueueButton.isHidden = false
                                
                                if QueueViewController.currentQueue!.queue.isEmpty {
                                    self.callNextButton.isHidden = true
                                } else {
                                    self.callNextButton.isHidden = false
                                }
                                
                                self.tableView.reloadData()
                                
                                self.updateTotalPeopleLabel()
                                self.updateLineNumberLabel()
                                self.removeSpinner()
                            }
                        }
                        self.removeSpinner()
                        return
                    }
                    
                    // If found
                    QueueViewController.currentQueue = queue.first!
                    
                    DispatchQueue.main.async {
                        self.navigationItem.title = QueueViewController.currentQueue?.name
                        
                        self.notAuthorizedStackView.isHidden = true
                        self.emptyQueueStubLabel.isHidden = true
                        self.tableView.isHidden = false
                        
                        self.queueInfoStackView.isHidden = false
                        self.quitQueueButton.isHidden = false
                        
                        self.tableView.reloadData()
                        
                        self.updateTotalPeopleLabel()
                        self.updateLineNumberLabel()
                        self.removeSpinner()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.navigationItem.title = "Моя очередь"
                    self.notAuthorizedStackView.isHidden = false
                    self.removeSpinner()
                }
            }
            
            DispatchQueue.main.async {
                self.updateTotalPeopleLabel()
                self.updateLineNumberLabel()
            }
            self.removeSpinner()
        }
    }
}

// MARK: - UITableViewDataSource
extension QueueViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard QueueViewController.currentQueue != nil else { return 0 }
        guard QueueViewController.currentQueue?.queue.count != 0 else { return 0 }
        
        switch section {
        case 0:
            if QueueViewController.currentQueue!.ownerId == SceneDelegate.user?.id {
                return 1
            } else {
                return QueueViewController.currentQueue!.queue.count
            }
        case 1:
            return QueueViewController.currentQueue!.queue.count - 1
        default:
            return QueueViewController.currentQueue!.queue.count - 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard QueueViewController.currentQueue != nil else { return UITableViewCell() }
        
        let id = QueueViewController.currentQueue!.ownerId == SceneDelegate.user?.id ? OwnCreatedQueueItemTableViewCell.id : QueueItemTableViewCell.id
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        var user = User()
        
        switch indexPath.section {
        case 0:
            if QueueViewController.currentQueue!.ownerId == SceneDelegate.user?.id {
                user = QueueViewController.currentQueue!.queue.first!
            } else {
                user = QueueViewController.currentQueue!.queue[indexPath.row]
            }
        case 1:
            user = QueueViewController.currentQueue!.queue[indexPath.row + 1]
        default:
            break
        }
        
        if QueueViewController.currentQueue!.ownerId == SceneDelegate.user?.id {
            let ownCreatedQueueItemTableViewCell = cell as! OwnCreatedQueueItemTableViewCell
            ownCreatedQueueItemTableViewCell.setup(with: user, at: indexPath)
        } else {
            let queueItemTableViewCell = cell as! QueueItemTableViewCell
            queueItemTableViewCell.setup(with: user, at: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            guard QueueViewController.currentQueue != nil else { return "" }
            return QueueViewController.currentQueue!.ownerId == SceneDelegate.user?.id ? "Следующий" : ""
        case 1:
            return "Остальные"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            QueueViewController.currentQueue?.queue.remove(at: indexPath.row)
            updateTotalPeopleLabel()
            UITableView.transition(with: tableView, duration: 0.5, options: .transitionCrossDissolve, animations: { self.tableView.reloadData() }, completion: nil)
        case .insert:
            break
        case .none:
            break
        @unknown default:
            print("New editing styles had appeared")
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        guard QueueViewController.currentQueue != nil else { return .none }
        
        if QueueViewController.currentQueue!.ownerId == SceneDelegate.user?.id {
            return .delete
        } else {
            return .none
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard QueueViewController.currentQueue != nil else { return 1 }
        return QueueViewController.currentQueue!.ownerId == SceneDelegate.user?.id ? 2 : 1
    }
}

// MARK: - UITableViewDelegate
extension QueueViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard QueueViewController.currentQueue != nil else { return 0 }
        return QueueViewController.currentQueue!.ownerId == SceneDelegate.user?.id ? 80 : 120
    }
}

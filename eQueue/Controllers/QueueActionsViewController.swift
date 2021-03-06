//
//  QueueDetailViewController.swift
//  eQueue
//
//  Created by Георгий Кашин on 24.04.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class QueueActionsViewController: UIViewController {
    
    // MARK: Stored Properties
    var queue: Queue!
    let selectedRow: Int
    
    
    // MARK: Delegates
    var delegate: ControlQueueDelegate
    
    
    // MARK: TableView
    var tableView: UITableView!
    
    
    // MARK: Lazy Properties
    lazy var queueStatus: QueueStatus = {
        let isOwnQueue = SceneDelegate.user?.id == queue.ownerId
        var status: QueueStatus = .completed
        
        if isOwnQueue {
            if queue.status == "upcoming" {
                status = .ownUpcoming
            } else if queue.status == "past" {
                status = .ownCompleted
            }
        } else {
            if queue.status == "upcoming" {
                status = .upcoming
            } else if queue.status == "past" {
                status = .completed
            }
        }
        
        return status
    }()
    
    
    // MARK: Buttons
    let hideButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "hide"), for: .normal)
        return button
    }()
    
    let showQrButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "qrcode"), for: .normal)
        button.tintColor = .buttonDark()
        return button
    }()
    
    var actionButton = UIButton(title: "Начать", backgroundColor: .buttonDark(), titleColor: .white, isShadow: false)
    let changeButton = UIButton(title: "Изменить", backgroundColor: .white, titleColor: .darkText, font: .avenir16(), isShadow: false)
    
    let showPeopleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Показать участников", for: .normal)
        button.setTitleColor(.darkText, for: .normal)
        return button
    }()
    
    let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "bin"), for: .normal)
        button.tintColor = .buttonDark()
        return button
    }()
    
    
    // MARK: Labels
    let nameLabel = UILabel(text: "Название", font: .avenir20())
    let descriptionLabel = UILabel(text: "Описание", font: .avenir20())
    let startDateLabel = UILabel(text: "Дата", font: .avenir20())
    let peopleCountLabel = UILabel(text: "Участников", font: .avenir20())
    
    
    // MARK: Alerts
    let repeatQueueAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
    
    
    // MARK: Initializers
    init(queue: Queue, controlQueueDelegate: ControlQueueDelegate, selectedRow: Int) {
        self.queue = queue
        self.delegate = controlQueueDelegate
        self.selectedRow = selectedRow
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        updateUI()
        
        // Targets
        hideButton.addTarget(self, action: #selector(hideButtonTapped), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        changeButton.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        showQrButton.addTarget(self, action: #selector(showQrButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        updateUI()
    }
}

// MARK: - OBJC Methods
extension QueueActionsViewController {
    // MARK: Button's Targets
    @objc private func hideButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func removeButtonTapped() {
        NetworkManager.shared.deleteQueue(id: queue.id) { statusCode in
            guard statusCode == 204 else { return }
            
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    self.delegate.updateUI()
                }
            }
        }
    }
    
    @objc private func changeButtonTapped() {
        present(repeatQueueAlert, animated: true)
    }
    
    @objc private func actionButtonTapped() {
        switch queueStatus {
        case .ownUpcoming:
            NetworkManager.shared.callNext(id: queue.id) { statusCode in
                guard statusCode == 200 || statusCode == 204 else { return }
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        let tabBarController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController as! MainTabBarController
                        tabBarController.selectedIndex = 1
                    }
                }
            }
        case .ownCompleted:
            present(repeatQueueAlert, animated: true)
        case .upcoming:
            NetworkManager.shared.leaveQueue(id: queue.id) { statusCode in
                guard statusCode == 204 else { return }
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        self.delegate.updateUI()
                    }
                }
            }
        case .completed:
            NetworkManager.shared.deleteQueue(id: queue.id) { statusCode in
                guard statusCode == 204 else { return }
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        self.delegate.updateUI()
                    }
                }
            }
        }
    }
    
    @objc private func showQrButtonTapped() {
        let qrCodeVC = QRCodeViewController(qrWithText: "\(queue.id)")
        present(qrCodeVC, animated: true)
    }
    
    
    // MARK: Selectors
    @objc private func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        repeatQueueAlert.textFields?.last?.text = dateFormatter.getString(from: sender.date)
    }
}

// MARK: - UI
extension QueueActionsViewController {
    private func setupUI() {
        setupTableView()
        setupAlert()
        
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
    }
    
    private func setupTableView() {
        tableView = UITableView()
        let cellType = queue.ownerId == SceneDelegate.user?.id ? OwnCreatedQueueItemTableViewCell.self : QueueItemTableViewCell.self
        let cellId = queue.ownerId == SceneDelegate.user?.id ? OwnCreatedQueueItemTableViewCell.id : QueueItemTableViewCell.id
        tableView.register(cellType, forCellReuseIdentifier: cellId)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func updateUI() {
        setupLabels()
        setupButtons()
        
        // Qr Button
        view.addSubview(showQrButton)
        showQrButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            showQrButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            showQrButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
        ])
        
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
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        if view.bounds.size.height > 500 {
            view.addSubview(tableView)
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: showPeopleButton.bottomAnchor, constant: 20),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -20)
            ])
            
            showPeopleButton.setTitle("Скрыть участников", for: .normal)
        } else {
            tableView.removeFromSuperview()
            showPeopleButton.setTitle("Показать участников", for: .normal)
        }
    }
    
    private func setupLabels() {
        nameLabel.text = queue.name
        descriptionLabel.text = queue.description
        startDateLabel.text = queue.startDate
        peopleCountLabel.text = "Участников: \(queue.queue.count)"
    }
    
    private func setupButtons() {
        switch queueStatus {
        case .ownUpcoming:
            actionButton.setTitle("Начать", for: .normal)
            changeButton.isHidden = false
            removeButton.isHidden = false
            showQrButton.isHidden = false
        case .ownCompleted:
            actionButton.setTitle("Повторить", for: .normal)
            changeButton.isHidden = true
            removeButton.isHidden = false
            showQrButton.isHidden = true
        case .upcoming:
            actionButton.setTitle("Покинуть", for: .normal)
            changeButton.isHidden = true
            removeButton.isHidden = true
            showQrButton.isHidden = true
        case .completed:
            actionButton.setTitle("Удалить", for: .normal)
            changeButton.isHidden = true
            removeButton.isHidden = true
            showQrButton.isHidden = true
        }
    }
    
    private func setupAlert() {
        repeatQueueAlert.addTextField { textField in
            textField.text = self.nameLabel.text
        }
        
        repeatQueueAlert.addTextField { textField in
            textField.text = self.descriptionLabel.text
        }
        
        repeatQueueAlert.addTextField { textField in
            textField.text = self.startDateLabel.text
            
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .dateAndTime
            datePicker.backgroundColor = .white
            datePicker.minimumDate = Date()
            datePicker.addTarget(self, action: #selector(self.handleDatePicker), for: .valueChanged)
            
            textField.inputView = datePicker
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        
        var alertTitle = ""
        var actionTitle = ""
        if queueStatus == .ownUpcoming {
            alertTitle = "Изменить очередь"
            actionTitle = "Изменить"
        } else if queueStatus == .ownCompleted {
            alertTitle = "Повторить очередь"
            actionTitle = "Повторить"
        }
        
        repeatQueueAlert.title = alertTitle
        
        let okAction = UIAlertAction(title: actionTitle, style: .default) { _ in
            self.queue.name = self.repeatQueueAlert.textFields![0].text!
            self.queue.description = self.repeatQueueAlert.textFields![1].text!
            self.queue.startDate = self.repeatQueueAlert.textFields![2].text!
            
            if self.queueStatus == .ownUpcoming {
                NetworkManager.shared.updateQueue(queue: self.queue) { statusCode in
                    guard statusCode == 200 else { return }
                    
                    DispatchQueue.main.async {
                        //                        self.dismiss(animated: true) {
                        self.delegate.updateUI()
                        self.nameLabel.text = self.repeatQueueAlert.textFields![0].text!
                        self.descriptionLabel.text = self.repeatQueueAlert.textFields![1].text!
                        self.startDateLabel.text = self.repeatQueueAlert.textFields![2].text!
                        //                        }
                    }
                }
            } else if self.queueStatus == .ownCompleted {
                NetworkManager.shared.createQueue(queue: self.queue) { queue in
                    guard var queue = queue else { return }
                    
                    queue.status = "upcoming"
                    queue.queue = [User]()
                    
                    DispatchQueue.main.async {
                        let qrCodeVC = QRCodeViewController(qrWithText: "\(queue.id)")
                        qrCodeVC.createQueueDelegate = self
                        
                        self.present(qrCodeVC, animated: true) {
                            self.delegate.updateUI()
                        }
                    }
                }
            }
        }
        
        repeatQueueAlert.addAction(okAction)
        repeatQueueAlert.addAction(cancelAction)
    }
}


// MARK: - CreateQueueDelegate
extension QueueActionsViewController: CreateQueueDelegate {
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - UITableViewDelegate
extension QueueActionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


// MARK: - UITableViewDataSource
extension QueueActionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queue.queue.count
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
            queueItemTableViewCell.setup(with: user, at: indexPath)
        }
        
        return cell
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

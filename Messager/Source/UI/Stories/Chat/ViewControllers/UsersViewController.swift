//
//  MessageViewController.swift
//  Messager
//
//  Created by Silchenko on 23.10.2018.
//

import UIKit
import JGProgressHUD

protocol UsersViewControllerDelegate: class {
    
    func didSelectCell(with user: User, from viewController: UsersViewController)
    func didTouchAddUserButton(from viewController: UsersViewController)
    func didRefreshUsers(from viewController: UsersViewController)
}

class UsersViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    weak var delegate: UsersViewControllerDelegate?
    private var users = [User]()
    private let cellHeight: CGFloat = 80.5
    private var progress: JGProgressHUD?
    private var refresh: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerUserCell()
        createAddUserButton()
        setActivityIndicator()
        createRefreshTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isUserInteractionEnabled = true
        tableView.reloadData()
    }
    
    func refreshData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func configure(users: [User]) {
        self.users = users
        if let tableView = tableView {
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }
    
    func downloaded(users: [User]) {
        for user in users {
            if !self.users.contains(user) {
                self.users.append(user)
            }
        }
        cancelRefresh()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func cancelRefresh() {
        DispatchQueue.main.async {
            self.progress?.dismiss()
            self.refresh?.endRefreshing()
        }
    }
    
    private func setActivityIndicator() {
        progress = JGProgressHUD(style: .dark)
        progress?.show(in: self.view)
    }
    
    private func registerUserCell() {
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    private func createAddUserButton() {
        let addUserButton = UIBarButtonItem(title: "Add user",
                                               style: .done,
                                              target: self,
                                              action: #selector(UsersViewController.addUserButtonTapped))
        self.navigationItem.rightBarButtonItem = addUserButton
    }
    
    private func createRefreshTableView() {
        refresh = UIRefreshControl()
        refresh?.addTarget(self, action: #selector(UsersViewController.refreshTableView), for: .allEvents)
        tableView.addSubview(refresh!)
    }
    
    @objc private func refreshTableView() {
        delegate?.didRefreshUsers(from: self)
    }
    
    @objc private func addUserButtonTapped() {
        delegate?.didTouchAddUserButton(from: self)
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserCell
        cell.configure(model: UserCellViewModel(userName: users[indexPath.row].name,
                                            lastMessage: users[indexPath.row].messages.sorted{}.last,
                                         lastMessageTime: nil,
                                            userImageUrl: users[indexPath.row].imageUrl))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isUserInteractionEnabled = false
        delegate?.didSelectCell(with: users[indexPath.row], from: self)
    }
}

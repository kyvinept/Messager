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
}

class UsersViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    weak var delegate: UsersViewControllerDelegate?
    private var users = [User]()
    private let cellHeight: CGFloat = 80.5
    private var progress: JGProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerUserCell()
        createAddUserButton()
        self.setActivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isUserInteractionEnabled = true
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
        self.users = users
        cancelRefresh()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func cancelRefresh() {
        DispatchQueue.main.async {
            self.progress?.dismiss()
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
                                             lastMessage: nil,
                                         lastMessageTime: nil))
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

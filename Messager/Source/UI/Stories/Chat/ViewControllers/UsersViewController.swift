//
//  MessageViewController.swift
//  Messager
//
//  Created by Silchenko on 23.10.2018.
//

import UIKit

protocol UsersViewControllerDelegate: class {
    
    func didSelectCell(with user: User, from viewController: UsersViewController)
}

class UsersViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    weak var delegate: UsersViewControllerDelegate?
    private var users = [User]()
    private let cellHeight: CGFloat = 80.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerUserCell()
    }
    
    func configure(users: [User]) {
        self.users = users
    }
    
    private func registerUserCell() {
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "Cell")
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
        delegate?.didSelectCell(with: users[indexPath.row], from: self)
    }
}

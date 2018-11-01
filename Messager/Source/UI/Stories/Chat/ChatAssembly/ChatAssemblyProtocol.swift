//
//  ChatAssemblyProtocol.swift
//  Messager
//
//  Created by Silchenko on 23.10.2018.
//

import UIKit

protocol ChatAssemblyProtocol {
    
    var appAssembly: ApplicationAssembly { get }
    
    func createChatViewController(currentUser: User, toUser: User) -> ChatViewController
    func createUsersViewController(with users: [User]) -> UsersViewController
    func createAddUserViewController() -> AddUserViewController
}

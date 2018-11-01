//
//  ChatAssembly.swift
//  Messager
//
//  Created by Silchenko on 23.10.2018.
//

import UIKit

class ChatAssembly: ChatAssemblyProtocol {
    
    var appAssembly: ApplicationAssembly
    
    init(appAssembly: ApplicationAssembly) {
        self.appAssembly = appAssembly
    }
    
    func createChatViewController(currentUser: User, toUser: User) -> ChatViewController {
        let vc = getStoryboard().instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.title = "Chats"
        vc.configure(with: currentUser, toUser: toUser)
        return vc
    }
    
    func createUsersViewController(with users: [User]) -> UsersViewController {
        let vc = getStoryboard().instantiateViewController(withIdentifier: "UsersViewController") as! UsersViewController
        vc.title = "Users"
        vc.configure(users: users)
        return vc
    }
    
    func createAddUserViewController() -> AddUserViewController {
        let vc = getStoryboard().instantiateViewController(withIdentifier: "AddUserViewController") as! AddUserViewController
        return vc
    }
    
    private func getStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Chat", bundle: nil)
    }
}

//
//  Chatrouter.swift
//  Messager
//
//  Created by Silchenko on 23.10.2018.
//

import UIKit

class ChatRouter: BaseRouter, ChatRouterProtocol {

    var assembly: ChatAssembly
    private var chatViewController: ChatViewController?
    lazy var currentUser: User? = {
        return assembly.appAssembly.authorizationManager.currentUser
    }()
    
    init(assembly: ChatAssembly) {
        self.assembly = assembly
    }
    
    func showInitialVC(from rootViewController: UIViewController) {
        let toUser = User(email: "b@gmail.com", name: "name", password: nil, id: "05260029-BD82-1E22-FF0C-A1DF8CD38200", userToken: nil)
        showChatVC(from: rootViewController, currentUser: currentUser!, toUser: toUser)
    }
    
    private func showChatVC(from rootViewController: UIViewController, currentUser: User, toUser: User) {
        let vc = assembly.createChatViewController(currentUser: currentUser, toUser: toUser)
        vc.delegate = self
        self.chatViewController = vc
        action(with: vc,
               from: rootViewController,
               with: .push,
           animated: true)
    }
}

extension ChatRouter: ChatViewControllerDelegate {
    
    func didTouchSendMessageButton(with message: Message, toUser: User, viewController: ChatViewController) {
        assembly.appAssembly.apiManager.saveMessage(fromUser: currentUser!, toUser: toUser, message: message)
    }
}

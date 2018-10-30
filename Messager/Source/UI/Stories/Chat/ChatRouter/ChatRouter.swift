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
    private var usersViewController: UsersViewController?
    lazy var currentUser: User? = {
        return assembly.appAssembly.authorizationManager.currentUser
    }()
    
    init(assembly: ChatAssembly) {
        self.assembly = assembly
    }
    
    func showInitialVC(from rootViewController: UIViewController) {
//        let vc = self.assembly.createChatViewController(currentUser: currentUser!, toUser: currentUser!)
//        vc.delegate = self
//        self.chatViewController = vc
//        self.action(with: vc,
//                    from: rootViewController,
//                    with: .push,
//                    animated: true)
//        rootViewController.tabBarController?.tabBar.isHidden = true
        showUsersViewController(from: rootViewController)
    }
    
    private func showUsersViewController(from rootViewController: UIViewController) {
        assembly.appAssembly.apiManager
        .getUsers(successBlock: { (users) in
                                    var allUsers = users
                                    allUsers?.removeAll { $0.email == self.currentUser!.email && $0.id == self.currentUser!.id && $0.name == self.currentUser!.name }
                                    let vc = self.assembly.createUsersViewController(with: allUsers ?? [User]())
                                    vc.delegate = self
                                    self.usersViewController = vc
                                    self.action(with: vc,
                                                from: rootViewController,
                                                with: .push,
                                            animated: true)
                                }, errorBlock: { (error) in
                                    print("error")
                                })
    }
    
    private func showChatViewController(from viewController: UIViewController, currentUser: User, toUser: User) {
        assembly.appAssembly.apiManager
        .startRealtimeChat(fromUser: currentUser,
                             toUser: toUser,
                       successBlock: {
                           self.assembly.appAssembly.apiManager
                           .addMessageListener(successBlock: { messageKind in
                               self.chatViewController?.showNewMessage(messageKind!)
                           }, errorBlock: { error in
                               print("error")
                           })
                           let vc = self.assembly.createChatViewController(currentUser: currentUser, toUser: toUser)
                           vc.delegate = self
                           self.chatViewController = vc
                           self.action(with: vc,
                                       from: viewController.navigationController!,
                                       with: .push,
                                   animated: true)
                           viewController.tabBarController?.tabBar.isHidden = true
                       }, errorBlock: { error in
                           print("error")
                       })
    }
}

extension ChatRouter: UsersViewControllerDelegate {
    
    func didSelectCell(with user: User, from viewController: UsersViewController) {
        showChatViewController(from: viewController, currentUser: currentUser!, toUser: user)
    }
}

extension ChatRouter: ChatViewControllerDelegate {
    
    func didTouchSendMessageButton(with message: Message, toUser: User, viewController: ChatViewController) {
        assembly.appAssembly.apiManager.publishMessage(message)
    }
    
    func didTouchBackButton(viewController: ChatViewController) {
        viewController.navigationController?.popViewController(animated: true)
        viewController.tabBarController?.tabBar.isHidden = false
    }
}

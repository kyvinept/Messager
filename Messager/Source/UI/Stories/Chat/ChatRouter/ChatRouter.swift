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
        var toUser = User(email: "b@gmail.com", name: "name", password: nil, id: "05260029-BD82-1E22-FF0C-A1DF8CD38200", userToken: nil)
        if currentUser!.id == "05260029-BD82-1E22-FF0C-A1DF8CD38200" {
            toUser = User(email: "a@gmail.com", name: "Pup", password: nil, id: "D935A236-A31E-8BEB-FF8E-63E5846AD300", userToken: nil)
        } else {
            toUser = User(email: "b@gmail.com", name: "name", password: nil, id: "05260029-BD82-1E22-FF0C-A1DF8CD38200", userToken: nil)
        }
        showChatVC(from: rootViewController, currentUser: currentUser!, toUser: toUser)
    }
    
    private func showChatVC(from rootViewController: UIViewController, currentUser: User, toUser: User) {
        assembly.appAssembly.apiManager
        .startRealtimeChat(fromUser: currentUser,
                             toUser: toUser,
                       successBlock: {
                           self.assembly.appAssembly.apiManager
                           .addMessageListener(successBlock: { message in
                               self.showNewMessage(message)
                           }, errorBlock: { error in
                               print(error)
                           })
                           let vc = self.assembly.createChatViewController(currentUser: currentUser, toUser: toUser)
                           vc.delegate = self
                           self.chatViewController = vc
                           self.action(with: vc,
                                       from: rootViewController,
                                       with: .push,
                                   animated: true)
                       }, errorBlock: { error in
                           print(error)
                       })
    }
}

extension ChatRouter: ChatViewControllerDelegate {
    
    func didTouchSendMessageButton(with message: Message, toUser: User, viewController: ChatViewController) {
        assembly.appAssembly.apiManager.publishMessage(message)
    }
    
    private func showNewMessage(_ message: String?) {
        chatViewController?.showNewMessage(message ?? "")
    }
}

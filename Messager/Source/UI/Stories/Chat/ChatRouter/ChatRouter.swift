//
//  Chatrouter.swift
//  Messager
//
//  Created by Silchenko on 23.10.2018.
//

import UIKit

class ChatRouter: BaseRouter, ChatRouterProtocol {

    var assembly: ChatAssembly
    
    init(assembly: ChatAssembly) {
        self.assembly = assembly
    }
    
    func showInitVC(from rootViewController: UIViewController) {
        action(with: assembly.chatVC(),
               from: rootViewController,
               with: .push,
           animated: true)
    }
}

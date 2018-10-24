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
    
    func chatVC() -> ChatViewController {
        let vc = getStoryboard().instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.title = "Chats"
        return vc
    }
    
    func messageVC() -> MessageViewController {
        let vc = getStoryboard().instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        vc.title = "Messages"
        return vc
    }
    
    private func getStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Chat", bundle: nil)
    }
}

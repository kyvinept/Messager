//
//  UserCellViewModel.swift
//  Messager
//
//  Created by Silchenko on 29.10.2018.
//

import UIKit

struct UserCellViewModel {
    
    var userName: String
    var lastMessage: String
    var lastMessageTime: String?
    var userImageUrl: String
    
    init(userName: String, lastMessage: Message?, lastMessageTime: Date?, userImageUrl: String) {
        self.userName = userName
        self.userImageUrl = userImageUrl
        if let date = lastMessageTime {
            self.lastMessageTime = date.toString(dateFormat: "HH:mm")
        }
        
        guard let lastMessage = lastMessage else {
            self.lastMessage = "no messages"
            return
        }
        
        self.lastMessage = lastMessage.kind.rawValue
//        switch lastMessage.kind {
//        case .text(let text):
//            self.lastMessage = text
//        case .photo(_):
//            self.lastMessage = "[photo]"
//        case .giphy(_):
//            self.lastMessage = "[giphy]"
//        case .location(_):
//            self.lastMessage = "[location]"
//        case .video(_):
//            self.lastMessage = "[video]"
//        case .answer(let text):
//            self.lastMessage = text
//        }
        self.lastMessageTime = lastMessage.sentDate.toString(dateFormat: "HH:mm")
    }
}

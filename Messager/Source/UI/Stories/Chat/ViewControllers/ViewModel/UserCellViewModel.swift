//
//  UserCellViewModel.swift
//  Messager
//
//  Created by Silchenko on 29.10.2018.
//

import UIKit

struct UserCellViewModel {
    
    var userName: String
    var lastMessage: String?
    var lastMessageTime: String?
    var userImageUrl: String
    
    init(userName: String, lastMessage: String?, lastMessageTime: Date?, userImageUrl: String) {
        self.userName = userName
        self.lastMessage = lastMessage
        self.userImageUrl = userImageUrl
        if let date = lastMessageTime {
            self.lastMessageTime = date.toString()
        }
    }
}

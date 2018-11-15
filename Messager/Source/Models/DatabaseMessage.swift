//
//  DatabaseMessage.swift
//  Messager
//
//  Created by Silchenko on 02.11.2018.
//

import UIKit

class DatabaseMessage {
    
    var sentDate: String
    var messageId: String
    var ownerId:String
    var toUserId:String
    var text: String?
    var image: String?
    var location: String?
    
    init(sentDate: String, messageId: String, ownerId:String, toUserId:String, text: String?, image: String?, location: String?) {
        self.sentDate = sentDate
        self.messageId = messageId
        self.ownerId = ownerId
        self.toUserId = toUserId
        self.text = text
        self.image = image
        self.location = location
    }
}

//
//  Message.swift
//  Messager
//
//  Created by Silchenko on 24.10.2018.
//

import UIKit

enum MessageKind {

    case text(String)
    case photo(MediaItem)
}

class Message: Equatable {
    
    var sender: User
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    init(sender: User, messageId: String, sentDate: Date, kind: MessageKind) {
        self.sender = sender
        self.messageId = messageId
        self.sentDate = sentDate
        self.kind = kind
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        if lhs.sender == rhs.sender && lhs.sentDate.toString() == rhs.sentDate.toString() {
            return true
        }
        return false
    }
}

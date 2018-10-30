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

struct Message {
    
    var sender: User
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

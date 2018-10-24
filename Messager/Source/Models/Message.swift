//
//  Message.swift
//  Messager
//
//  Created by Silchenko on 24.10.2018.
//

import UIKit
import MessageKit

struct Message: MessageType {
    
    var sender: Sender
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

//
//  Message.swift
//  Messager
//
//  Created by Silchenko on 24.10.2018.
//

import UIKit

enum MessageKind {
    case text(String)
    case answer(String)
    case photo(MediaItem)
    case video(VideoItem)
    case location(CLLocationCoordinate2D)
    case giphy(Giphy)
}

extension MessageKind: RawRepresentable {
    
    public typealias RawValue = String
    
    public init?(rawValue: RawValue) {
        return nil
    }
    
    public var rawValue: RawValue {
        switch self {
        case .text(let text):
            return text
        case .answer(let text):
            return text
        case .photo(_):
            return "[photo]"
        case .video(_):
            return "[video]"
        case .giphy(_):
            return "[giphy]"
        case .location(_):
            return "[location]"
        }
    }
}

class Message: Equatable {
    
    var sender: User
    var answer: String?
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    init(sender: User, answer: String?, messageId: String, sentDate: Date, kind: MessageKind) {
        self.sender = sender
        self.answer = answer
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

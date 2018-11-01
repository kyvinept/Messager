//
//  DatabaseMapper.swift
//  Messager
//
//  Created by Silchenko on 01.11.2018.
//

import UIKit

class DatabaseMapper {
    
    private enum MessageType: String {
        
        case text
        case image
    }
    
    func map(userEntity: UserEntity, from user: User) {
        userEntity.email = user.email
        userEntity.id = user.id
        userEntity.name = user.name
    }
    
    func map(to messageEntity: MessageEntity, from message: Message) {
        messageEntity.messageId = message.messageId
        messageEntity.sentDate = message.sentDate
        
        switch message.kind {
        case .text(let text):
            messageEntity.type = MessageType.text.rawValue
            messageEntity.text = text
        case .photo(let mediaItem):
            messageEntity.type = MessageType.image.rawValue
            messageEntity.image = UIImageJPEGRepresentation(mediaItem.image, 1.0)
        }
    }
    
    func map(messagesEntity: [MessageEntity]) -> [Message] {
        var newMessages = [Message]()
        for messageEntity in messagesEntity {
            let message = map(messageEntity: messageEntity)
            newMessages.append(message)
        }
        return newMessages
    }

    func map(users: [UserEntity]) -> [User] {
        var newUsers = [User]()
        for user in users {
            let newUser = map(user: user)
            newUsers.append(newUser)
        }
        return newUsers
    }
    
    private func map(user: UserEntity) -> User {
        return User(email: user.email!,
                     name: user.name!,
                 password: user.password,
                       id: user.id!,
                userToken: user.userToken)
    }
    
    private func map(messageEntity: MessageEntity) -> Message {
        var messageKind = MessageKind.text("")
        switch messageEntity.type! {
        case MessageType.image.rawValue:
            if let data = messageEntity.image, let image = UIImage(data: data) {
                messageKind = MessageKind.photo(MediaItem(image: image, size: image.getSizeForMessage()))
            }
        case MessageType.text.rawValue:
            messageKind = MessageKind.text(messageEntity.text!)
        default:
            break
        }
        
        return Message(sender: map(user: messageEntity.sender!),
                    messageId: messageEntity.messageId!,
                     sentDate: messageEntity.sentDate!,
                         kind: messageKind)
    }
}

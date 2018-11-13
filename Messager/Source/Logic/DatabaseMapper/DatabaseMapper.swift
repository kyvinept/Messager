//
//  DatabaseMapper.swift
//  Messager
//
//  Created by Silchenko on 01.11.2018.
//

import UIKit

enum MessageType: String {
    case text
    case image
}

class DatabaseMapper {
    
    func map(userEntity: UserEntity, from user: User) {
        userEntity.email = user.email
        userEntity.id = user.id
        userEntity.name = user.name
        userEntity.imageUrl = user.imageUrl
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
        case .location(let location):
            break
        }
    }
    
    func map(messagesEntity: [MessageEntity], currentUser: User, toUser: User) -> [Message] {
        var newMessages = [Message]()
        for messageEntity in messagesEntity {
            let message = map(messageEntity: messageEntity,
                                currentUser: currentUser,
                                     toUser: toUser)
            newMessages.append(message)
        }
        newMessages.sort { $0.sentDate < $1.sentDate }
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
                userToken: user.userToken,
                 imageUrl: user.imageUrl!)
    }
    
    private func map(messageEntity: MessageEntity, currentUser: User, toUser: User) -> Message {
        var messageKind = MessageKind.text("")
        switch messageEntity.type! {
        case MessageType.image.rawValue:
            if let data = messageEntity.image, let image = UIImage(data: data) {
                messageKind = MessageKind.photo(MediaItem(image: image, size: image.getSizeForMessage(), downloaded: true))
            }
        case MessageType.text.rawValue:
            messageKind = MessageKind.text(messageEntity.text!)
        default:
            break
        }
        
        var user = currentUser
        switch messageEntity.direction {
        case MessageDirection.from.rawValue:
            user = map(user: messageEntity.user!)
        case MessageDirection.to.rawValue:
            user = currentUser
        default:
            break
        }
        
        return Message(sender: user,
                    messageId: messageEntity.messageId!,
                     sentDate: messageEntity.sentDate!,
                         kind: messageKind)
    }
}

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
    case video
    case location
    
    case giphy
    case giphySize
    
    case push
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
            messageEntity.type = MessageType.location.rawValue
            messageEntity.location = "\(location.latitude),\(location.longitude)"
        case .video(let videoItem):
            messageEntity.type = MessageType.video.rawValue
            messageEntity.video = videoItem.videoUrl.absoluteString
        case .giphy(let giphy):
            messageEntity.type = MessageType.giphy.rawValue
            messageEntity.giphy = giphy.url
            messageEntity.giphyWidth = Float(giphy.width)
            messageEntity.giphyHeight = Float(giphy.height)
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
        case MessageType.location.rawValue:
            let locationSplit = messageEntity.location!.split(separator: ",")
            let latitude = Double(locationSplit[0])!
            let longitude = Double(locationSplit[1])!
            messageKind = MessageKind.location(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        case MessageType.video.rawValue:
            messageKind = MessageKind.video(VideoItem(videoUrl: URL(string: messageEntity.video!)!, downloaded: true))
        case MessageType.giphy.rawValue:
            messageKind = MessageKind.giphy(Giphy(id: String(messageEntity.giphy!.split(separator: "/")[4]),
                                                 url: messageEntity.giphy!,
                                              height: CGFloat(messageEntity.giphyHeight),
                                               width: CGFloat(messageEntity.giphyWidth)))
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

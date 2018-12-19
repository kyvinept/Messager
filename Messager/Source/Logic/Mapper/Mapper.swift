//
//  Mapper.swift
//  Messager
//
//  Created by Silchenko on 31.10.2018.
//

import UIKit
import GiphyCoreSDK
import SwiftyJSON

protocol GiphyMapperProtocol {
    func map(jsonGiphy: JSON) -> [Giphy]
}

class Mapper {
    
    init() {   }
    
    func mapUser(fromBackendlessUser backendlessUser: BackendlessUser) -> User {
        let newUser = User(email: String(backendlessUser.email),
                            name: String(backendlessUser.name),
                        password: nil,
                              id: String(backendlessUser.objectId),
                       userToken: backendlessUser.getToken())
        return newUser
    }
    
    func mapAllUsers(users: [[String: Any]]) -> [User] {
        var newUsers = [User]()
        for user in users {
            newUsers.append(self.map(user: user))
        }
        return newUsers
    }
    
    func map(message: [String: Any]) -> Message {
        return Message(sender: map(user: message["sender"] as! [String: String]),
                       answer: message["answer"] as? String,
                    messageId: message["messageId"] as! String,
                     sentDate: (message["sentDate"] as! String).toDate()!,
                         kind: MessageKind.text(""))
    }
    
    private func map(user: [String: Any]) -> User {
        return User(email: user["email"] as! String,
                     name: user["name"] as! String,
                 password: nil,
                       id: user["id"] as? String ?? user["ownerId"] as! String,
                userToken: nil,
                 imageUrl: user["image"] as! String)
    }
    
    func createRequest(message: Message, toUser: User) -> [String: Any] {
        let request: [String: Any] = ["sentDate": message.sentDate.toString(),
                                     "messageId": message.messageId,
                                       "ownerId": message.sender.id,
                                      "toUserId": toUser.id,
                                        "sender": ["id": message.sender.id,
                                                "email": message.sender.email,
                                                 "name": message.sender.name,
                                                "image": message.sender.imageUrl]]
        return request
    }
    
    func mapAllMessages(messages: [[String: Any]]) -> [DatabaseMessage] {
        var newMessages = [DatabaseMessage]()
        for message in messages {
            newMessages.append(mapMessageFromDatabase(message))
        }
        return newMessages
    }
    
    private func mapMessageFromDatabase(_ message: [String: Any]) -> DatabaseMessage {
        return DatabaseMessage(sentDate: message["sentDate"] as! String,
                              messageId: message["messageId"] as! String,
                                ownerId: message["ownerId"] as! String,
                               toUserId: message["toUserId"] as! String,
                                   text: message[MessageType.text.rawValue] as! String?,
                                  image: message[MessageType.image.rawValue] as! String?,
                               location: message[MessageType.location.rawValue] as! String?,
                                  video: message[MessageType.video.rawValue] as! String?,
                                  giphy: message[MessageType.giphy.rawValue] as! String?,
                              giphySize: message[MessageType.giphySize.rawValue] as! String?,
                                 answer: message[MessageType.answer.rawValue] as! String?)
    }
    
    func map(images: [[String: Any]]) -> [Image] {
        var newImagesUrl = [Image]()
        for image in images {
            newImagesUrl.append(Image(url: image["url"] as! String,
                                isMyImage: (image["ownerId"] as? String) == nil ? false : true))
        }
        return newImagesUrl
    }
}

extension Mapper: GiphyMapperProtocol {
    
    func map(jsonGiphy json: JSON) -> [Giphy] {
        var giphy = [Giphy]()
        var index = 0
        var object = json["data"][index]
        
        while object != JSON.null {
            let height = object["images"]["fixed_width_small"]["height"].floatValue
            let width = object["images"]["fixed_width_small"]["width"].floatValue
            
            giphy.append(Giphy(id: object["id"].string!,
                              url: object["url"].string!,
                           height: CGFloat(height/width*150),
                            width: 150))
            index+=1
            object = json["data"][index]
        }
        return giphy
    }
}

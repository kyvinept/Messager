//
//  Mapper.swift
//  Messager
//
//  Created by Silchenko on 31.10.2018.
//

import UIKit

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
                                   text: message["text"] as! String?,
                                  image: message["image"] as! String?,
                               location: message["location"] as! String?)
    }
}

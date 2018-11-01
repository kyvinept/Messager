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
            newUsers.append(User(email: user["email"] as! String,
                                  name: user["name"] as! String,
                              password: nil,
                                    id: user["objectId"] as! String,
                             userToken: nil))
        }
        return newUsers
    }
    
    func map(message: [String: Any]) -> Message {
        return Message(sender: map(user: message["sender"] as! [String: String]),
                    messageId: message["messageId"] as! String,
                     sentDate: (message["sentDate"] as! String).toDate(),
                         kind: MessageKind.text(""))
    }
    
    private func map(user: [String: String]) -> User {
        return User(email: user["email"]!,
                     name: user["name"]!,
                 password: nil,
                       id: user["id"]!,
                userToken: nil)
    }
}

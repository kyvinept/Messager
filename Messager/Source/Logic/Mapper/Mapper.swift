//
//  Mapper.swift
//  Messager
//
//  Created by Silchenko on 31.10.2018.
//

import UIKit

class Mapper {
    
    init() {   }
 
    func createNewUser(user: BackendlessUser) -> User {
        let newUser = User(email: String(user.email),
                           name: String(user.name),
                           password: nil,
                           id: String(user.objectId),
                           userToken: user.getToken())
        return newUser
    }
    
    func allUsers(users: [[String: Any]]) -> [User] {
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
}

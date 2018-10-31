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
}

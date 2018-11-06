//
//  User.swift
//  Messager
//
//  Created by Silchenko on 23.10.2018.
//

import UIKit

class User: Equatable {
    
    var email: String
    var name: String
    var password: String?
    var id: String
    var userToken: String?
    var imageUrl: String
    
    init (email: String, name: String, password: String?, id: String, userToken: String?, imageUrl: String = ""){
        self.email = email
        self.name = name
        self.password = password
        self.id = id
        self.userToken = userToken
        self.imageUrl = imageUrl
    }

    static func == (lhs: User, rhs: User) -> Bool {
        if lhs.email == rhs.email && lhs.name == rhs.name && lhs.id == rhs.id {
            return true
        }
        return false
    }
}

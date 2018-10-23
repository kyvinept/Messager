//
//  AuthorizationManager.swift
//  Messager
//
//  Created by Silchenko on 23.10.2018.
//

import UIKit

class AuthorizationManager {
    
    private let APPLICATION_ID = "6750B226-C13A-6F57-FF65-037600EDE000"
    private let API_KEY = "BE8D84AE-A2FE-56B8-FF3A-98F4FD827900"
    private let SERVER_URL = "https://api.backendless.com"
    private let backendless = Backendless.sharedInstance()!
    
    init() {
        Backendless.sharedInstance().hostURL = SERVER_URL
        Backendless.sharedInstance().initApp(APPLICATION_ID, apiKey: API_KEY)
    }
    
    func login(withEmail email: String, password: String, successBlock: @escaping (User?) -> (), errorBlock: @escaping (Fault?) -> ()) {
        backendless.userService.login(email,
                                      password: password,
                                      response: { (user) in
                                          successBlock(self.createNewUser(user: user))
                                      },
                                         error: { (error) in
                                             errorBlock(error)
                                         })
    }
    
    func login() {
        //backendless.userService.login(withGoogleSDK: <#T##String!#>, accessToken: <#T##String!#>, response: <#T##((BackendlessUser?) -> Void)!##((BackendlessUser?) -> Void)!##(BackendlessUser?) -> Void#>, error: <#T##((Fault?) -> Void)!##((Fault?) -> Void)!##(Fault?) -> Void#>)
    }
    
    func register(with email: String, name: String, password: String, successBlock: @escaping (User?) -> (), errorBlock: @escaping (Fault?) -> ()) {
        let newUser = BackendlessUser(properties: ["email" : email, "name" : name, "password" : password])
        backendless.userService.register(newUser,
                                         response: { (user) in
                                             successBlock(self.createNewUser(user: user))
                                         }) { (error) in
                                             errorBlock(error)
                                         }
    }
    
    func passwordRecovery(with email: String, successBlock: @escaping () -> (), errorBlock: @escaping (Fault?) -> ()) {
        backendless.userService.restorePassword(email,
                                                response: {
                                                    successBlock()
                                                }) { (error) in
                                                    errorBlock(error)
                                                }
    }
    
    private func createNewUser(user: BackendlessUser?) -> User? {
        if let user = user {
            let newUser = User(email: String(user.email),
                                name: String(user.name),
                            password: nil,
                                  id: String(user.objectId),
                           userToken: user.getToken())
            return newUser
        }
        return nil
    }
}

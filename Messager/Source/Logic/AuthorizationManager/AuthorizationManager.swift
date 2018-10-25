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
    private var keychainManager: KeychainManager
    private(set) var currentUser: User?
    
    init(with keychainManager: KeychainManager) {
        Backendless.sharedInstance().hostURL = SERVER_URL
        Backendless.sharedInstance().initApp(APPLICATION_ID, apiKey: API_KEY)
        self.keychainManager = keychainManager
    }
    
    func isLoginUser() -> Bool {
        return keychainManager.hasEmail()
    }
    
    func login(withEmail email: String, password: String, successBlock: @escaping (User?) -> (), errorBlock: @escaping (Fault?) -> ()) {
        backendless.userService.login(email,
                                      password: password,
                                      response: { (user) in
                                          successBlock(self.checkCurrentUser(user: user))
                                      },
                                         error: { (error) in
                                             errorBlock(error)
                                         })
    }
    
    func register(with email: String, name: String, password: String, successBlock: @escaping (User?) -> (), errorBlock: @escaping (Fault?) -> ()) {
        let newUser = BackendlessUser(properties: ["email" : email, "name" : name, "password" : password])
        backendless.userService.register(newUser,
                                         response: { (user) in
                                             successBlock(self.checkCurrentUser(user: user))
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
    
    func logout(successBlock: @escaping () -> (), errorBlock: @escaping (Fault?) -> ()) {
        backendless.userService.logout({
            self.keychainManager.delete()
            successBlock()
        }) { (error) in
            print("error logout")
        }
    }
    
    private func checkCurrentUser(user: BackendlessUser?) -> User? {
        if let user = user {
            let newUser = self.createNewUser(user: user)
            self.currentUser = newUser
            self.keychainManager.save(email: newUser.email)
            return newUser
        }
        return nil
    }
    
    private func createNewUser(user: BackendlessUser) -> User {
        let newUser = User(email: String(user.email),
                            name: String(user.name),
                        password: nil,
                              id: String(user.objectId),
                       userToken: user.getToken())
        return newUser
    }
}

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
    private var mapper: Mapper
    private var databaseManager: DatabaseManager
    var currentUser: User {
        return keychainManager.getCurrentUser()
    }
    
    init(with keychainManager: KeychainManager, mapper: Mapper, databaseManager: DatabaseManager) {
        Backendless.sharedInstance().hostURL = SERVER_URL
        Backendless.sharedInstance().initApp(APPLICATION_ID, apiKey: API_KEY)
        self.keychainManager = keychainManager
        self.mapper = mapper
        self.databaseManager = databaseManager
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
    
    func logout() {
        keychainManager.delete()
        databaseManager.removeAddUsers()
    }
    
    private func checkCurrentUser(user: BackendlessUser?) -> User? {
        if let user = user {
            let newUser = mapper.mapUser(fromBackendlessUser: user)
            self.keychainManager.save(email: newUser.email,
                                         id: newUser.id,
                                       name: newUser.name)
            return newUser
        }
        return nil
    }
}

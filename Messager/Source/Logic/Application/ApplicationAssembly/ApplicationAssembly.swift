//
//  ApplicationAssembly.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

class ApplicationAssembly: ApplicationAssemblyProtocol {
    
    lazy var authorizationManager = self.createAuthorizationManager()
    lazy var apiManager = ApiManager()
    
    private func createAuthorizationManager() -> AuthorizationManager {
        let keychain = KeychainManager()
        return AuthorizationManager(with: keychain)
    }
        
    init() { }
}

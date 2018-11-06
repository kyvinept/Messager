//
//  ApplicationAssembly.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

class ApplicationAssembly: ApplicationAssemblyProtocol {
    
    lazy var authorizationManager = self.createAuthorizationManager()
    lazy var apiManager = self.createApiManager()
    lazy var databaseManager = DatabaseManager(databaseMapper: databaseMapper)
    
    lazy private var imageManager = ImageManager()
    lazy private var mapper = Mapper()
    lazy private var databaseMapper = DatabaseMapper()
    
    private func createAuthorizationManager() -> AuthorizationManager {
        let keychain = KeychainManager()
        return AuthorizationManager(with: keychain, mapper: mapper, databaseManager: databaseManager, imageManager: imageManager, apiManager: apiManager)
    }
    
    private func createApiManager() -> ApiManager {
        return ApiManager(mapper: mapper, imageManager: imageManager, databaseManager: databaseManager)
    }
}

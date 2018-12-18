//
//  ApplicationAssembly.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

class ApplicationAssembly: ApplicationAssemblyProtocol {
    
    lazy var authorizationManager = createAuthorizationManager()
    lazy var apiManager = createApiManager()
    lazy var databaseManager = DatabaseManager(databaseMapper: databaseMapper)
    lazy var locationManager = LocationManager()
    lazy var giphyManager = GiphyManager(mapper: mapper)
    lazy var keychainManager = KeychainManager()
    lazy var notificationManager = NotificationManager(databaseManager: databaseManager)
    lazy var userDefaultsManager = UserDefaultsManager()
    
    lazy private var mediaManager = MediaManager()
    lazy private var mapper = Mapper()
    lazy private var databaseMapper = DatabaseMapper()
    
    private func createAuthorizationManager() -> AuthorizationManager {
        return AuthorizationManager(with: keychainManager, mapper: mapper, databaseManager: databaseManager, imageManager: mediaManager, apiManager: apiManager)
    }
    
    private func createApiManager() -> ApiManager {
        return ApiManager(mapper: mapper,
                    mediaManager: mediaManager,
                 databaseManager: databaseManager,
             notificationManager: notificationManager)
    }
}

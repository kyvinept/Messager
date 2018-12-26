//
//  ApplicationAssemblyProtocol.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

protocol ApplicationAssemblyProtocol {
    
    var authorizationManager: AuthorizationManager { get }
    var apiManager: ApiManager { get }
    var giphyManager: GiphyManager { get }
    var databaseManager: DatabaseManager { get }
    var locationManager: LocationManager { get }
    var keychainManager: KeychainManager { get }
    var notificationManager: NotificationManager { get }
    var userDefaultsManager: UserDefaultsManager { get }
    var shareServices: ShareServices { get }
}

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
}

//
//  AuthorizationRouterProtocol.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

protocol AuthorizationRouterProtocol {
    
    var assembly: AuthorizationAssembly { get }
    var rootViewController: UIViewController { get }
    
    func showInitVC()
}

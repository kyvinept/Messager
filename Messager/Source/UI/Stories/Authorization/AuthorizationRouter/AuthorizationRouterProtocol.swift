//
//  AuthorizationRouterProtocol.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

protocol AuthorizationRouterProtocol {
    
    var assembly: AuthorizationAssemblyProtocol { get }
    
    func showInitialVC(from viewController: UIViewController)
}

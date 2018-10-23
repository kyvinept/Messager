//
//  AuthorizationAssemblyProtocol.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

protocol AuthorizationAssemblyProtocol {
    
    var assembly: MainUIAssembly { get }
    
    func loginVC() -> LoginViewController
    func registrationVC() -> RegistrationViewController
}

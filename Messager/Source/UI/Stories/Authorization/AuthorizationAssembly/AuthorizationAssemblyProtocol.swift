//
//  AuthorizationAssemblyProtocol.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

protocol AuthorizationAssemblyProtocol {
    
    var appAssembly: ApplicationAssembly { get }
    
    func loginVC() -> LoginViewController
    func registrationVC() -> RegistrationViewController
    func passwordRecoveryVC() -> PasswordRecoveryViewController
}

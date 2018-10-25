//
//  AuthorizationAssemblyProtocol.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

protocol AuthorizationAssemblyProtocol {
    
    var appAssembly: ApplicationAssembly { get }
    
    func createLoginViewController() -> LoginViewController
    func createRegistrationViewController() -> RegistrationViewController
    func createPasswordRecoveryViewController() -> PasswordRecoveryViewController
}

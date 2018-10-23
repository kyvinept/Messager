//
//  AuthorizationAssembly.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

class AuthorizationAssembly: AuthorizationAssemblyProtocol {
    
    var appAssembly: ApplicationAssembly
    
    init(appAssembly: ApplicationAssembly) {
        self.appAssembly = appAssembly
    }
    
    func loginVC() -> LoginViewController {
        let vc = getStoryboard().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.title = "Login"
        return vc
    }
    
    func registrationVC() -> RegistrationViewController {
        let vc = getStoryboard().instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        vc.title = "Register"
        return vc
    }
    
    func passwordRecoveryVC() -> PasswordRecoveryViewController {
        let vc = getStoryboard().instantiateViewController(withIdentifier: "PasswordRecoveryViewController") as! PasswordRecoveryViewController
        vc.title = "Restore password"
        return vc
    }
    
    private func getStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Authorization", bundle: nil)
    }
}

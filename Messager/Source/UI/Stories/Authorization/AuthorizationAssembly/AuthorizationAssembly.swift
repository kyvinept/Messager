//
//  AuthorizationAssembly.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

class AuthorizationAssembly: AuthorizationAssemblyProtocol {
    
    var assembly: MainUIAssembly
    
    init(assembly: MainUIAssembly) {
        self.assembly = assembly
    }
    
    func loginVC() -> LoginViewController {
        return getStoryboard().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    }
    
    func registrationVC() -> RegistrationViewController {
        return getStoryboard().instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
    }
    
    private func getStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Authorization", bundle: nil)
    }
}

//
//  AuthorizationRouter.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

class AuthorizationRouter: BaseRouter, AuthorizationRouterProtocol {
    
    var assembly: AuthorizationAssembly
    var rootViewController: UIViewController
    
    init(authorizationAssembly: AuthorizationAssembly, rootViewController: UIViewController) {
        self.assembly = authorizationAssembly
        self.rootViewController = rootViewController
    }
    
    func showRegistrationVC() {
        action(with: assembly.registrationVC(), from: rootViewController, with: .push, animated: true)
    }
    
    func showLoginVC() {
        let loginVC = assembly.loginVC()
        loginVC.delegate = self
        action(with: loginVC, from: rootViewController, with: .push, animated: true)
    }
    
    func showPasswordRecoveryVC() {
        
    }
}

extension AuthorizationRouter: LoginViewControllerDelegate {
    
    func loginViewController(viewController: LoginViewController, didTouchRegisterButton sender: UIButton) {
        showRegistrationVC()
    }
}

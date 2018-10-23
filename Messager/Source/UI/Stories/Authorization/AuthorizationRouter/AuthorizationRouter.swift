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
    
    func showInitVC() {
        showLoginVC()
    }
    
    private func showRegistrationVC() {
        let registerVC = assembly.registrationVC()
        registerVC.delegate = self
        registerVC.title = "Register"
        action(with: registerVC,
               from: rootViewController,
               with: .push,
           animated: true)
    }
    
    private func showLoginVC() {
        let loginVC = assembly.loginVC()
        loginVC.delegate = self
        loginVC.title = "Login"
        action(with: loginVC,
               from: rootViewController,
               with: .push,
           animated: true)
    }
    
    private func showPasswordRecoveryVC() {
        let passwordRecoveryVC = assembly.passwordRecoveryVC()
        passwordRecoveryVC.delegate = self
        passwordRecoveryVC.title = "Restore password"
        action(with: passwordRecoveryVC,
               from: rootViewController,
               with: .push,
           animated: true)
    }
}

extension AuthorizationRouter: LoginViewControllerDelegate {

    func registerButtonWasTapped(_ sender: UIButton) {
        showRegistrationVC()
    }

    func passwordRecovery(_ sender: UIButton) {
        showPasswordRecoveryVC()
    }

    func checkUserButtonTapped(with email: String, password: String, successBlock: @escaping (User?) -> (), errorBlock: @escaping (Fault?) -> ()) {
        assembly.assembly.appAssembly.authorizationManager.login(with: email,
                                                             password: password,
                                                         successBlock: successBlock,
                                                           errorBlock: errorBlock)
    }
}

extension AuthorizationRouter: RegistrationViewControllerDelegate {
  
    func registerUserButtonTapped(with email: String, name: String, password: String, successBlock: @escaping (User?) -> (), errorBlock: @escaping (Fault?) -> ()) {
        assembly.assembly.appAssembly.authorizationManager.register(with: email,
                                                                    name: name,
                                                                password: password,
                                                            successBlock: successBlock,
                                                              errorBlock: errorBlock)
    }
}

extension AuthorizationRouter: PasswordRecoveryViewControllerDelegate {
    
    func passwordRecovery(with email: String, successBlock: @escaping () -> (), errorBlock: @escaping (Fault?) -> ()) {
        assembly.assembly.appAssembly.authorizationManager.passwordRecovery(with: email,
                                                                    successBlock: successBlock,
                                                                      errorBlock: errorBlock)
    }
}

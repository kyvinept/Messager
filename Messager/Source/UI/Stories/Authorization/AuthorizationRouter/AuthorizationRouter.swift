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
    
    init(assembly: AuthorizationAssembly, rootViewController: UIViewController) {
        self.assembly = assembly
        self.rootViewController = rootViewController
    }
    
    func showInitVC() {
        showLoginVC()
    }
    
    private func showInfo(to viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        viewController.present(alert,
                               animated: true,
                             completion: nil)
    }
    
    private func showRegistrationVC() {
        let registerVC = assembly.registrationVC()
        registerVC.delegate = self
        action(with: registerVC,
               from: rootViewController,
               with: .push,
           animated: true)
    }
    
    private func showLoginVC() {
        let loginVC = assembly.loginVC()
        loginVC.delegate = self
        action(with: loginVC,
               from: rootViewController,
               with: .push,
           animated: true)
    }
    
    private func showPasswordRecoveryVC() {
        let passwordRecoveryVC = assembly.passwordRecoveryVC()
        passwordRecoveryVC.delegate = self
        action(with: passwordRecoveryVC,
               from: rootViewController,
               with: .push,
           animated: true)
    }
}

extension AuthorizationRouter: LoginViewControllerDelegate {
    
    func loginViewController(viewController: LoginViewController, didTouchRegisterButton sender: UIButton) {
        showRegistrationVC()
    }
    
    func loginViewController(viewController: LoginViewController, didTouchPasswordRecoveryButton sender: UIButton) {
        showPasswordRecoveryVC()
    }
    
    func loginViewController(withEmail email: String, password: String, viewController: LoginViewController, didTouchLoginButton sender: UIButton) {
        assembly.appAssembly.authorizationManager.login(withEmail: email,
                                                                  password: password,
                                                              successBlock: { user in
                                                                  print("success")
                                                              },
                                                                errorBlock: { _ in
                                                                    self.showInfo(to: viewController,
                                                                               title: "Error",
                                                                             message: "Invalid email or password")
                                                                })
    }
}

extension AuthorizationRouter: RegistrationViewControllerDelegate {
    
    func registrationViewController(with email: String, name: String, password: String, viewController: RegistrationViewController, didTouchRegisterButton sender: UIButton) {
        assembly.appAssembly.authorizationManager.register(with: email,
                                                                    name: name,
                                                                password: password,
                                                            successBlock: { (_) in
                                                                print("success")
                                                            }) { error in
                                                                self.showInfo(to: viewController,
                                                                           title: "Error",
                                                                         message: error!.detail)
                                                            }
    }
}

extension AuthorizationRouter: PasswordRecoveryViewControllerDelegate {
    
    func passwordRecoveryViewController(with email: String, viewController: PasswordRecoveryViewController, didTouchRegisterButton sender: UIButton) {
        assembly.appAssembly.authorizationManager.passwordRecovery(with: email,
                                                                    successBlock: {
                                                                        print("success")
                                                                    }) { (_) in
                                                                        print("error")
                                                                    }
    }
}

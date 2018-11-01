//
//  AuthorizationRouter.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

protocol AuthorizationRouterDelegate: class {
    
    func authorizationStoryWasOver(from viewController: UIViewController)
}

class AuthorizationRouter: BaseRouter, AuthorizationRouterProtocol {

    var assembly: AuthorizationAssemblyProtocol
    weak var delegate: AuthorizationRouterDelegate?
    private var loginViewController: LoginViewController?
    private var registrationViewController: RegistrationViewController?
    private var passwordRecoveryViewController: PasswordRecoveryViewController?
    
    init(assembly: AuthorizationAssembly) {
        self.assembly = assembly
    }
    
    func showInitialVC(from viewController: UIViewController) {
        showLoginVC(from: viewController)
    }
    
    private func showInfo(to viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        viewController.present(alert,
                               animated: true,
                             completion: nil)
    }
    
    private func showRegistrationVC(from viewController: UIViewController) {
        let registerVC = assembly.createRegistrationViewController()
        registerVC.delegate = self
        self.registrationViewController = registerVC
        action(with: registerVC,
               from: viewController.navigationController!,
               with: .push,
           animated: true)
    }
    
    private func showLoginVC(from viewController: UIViewController) {
        let loginVC = assembly.createLoginViewController()
        loginVC.delegate = self
        self.loginViewController = loginVC
        action(with: loginVC,
               from: viewController,
               with: .push,
           animated: true)
    }
    
    private func showPasswordRecoveryVC(from viewController: UIViewController) {
        let passwordRecoveryVC = assembly.createPasswordRecoveryViewController()
        passwordRecoveryVC.delegate = self
        self.passwordRecoveryViewController = passwordRecoveryVC
        action(with: passwordRecoveryVC,
               from: viewController.navigationController!,
               with: .push,
           animated: true)
    }
}

extension AuthorizationRouter: LoginViewControllerDelegate {
    
    func loginViewController(viewController: LoginViewController, didTouchRegisterButton sender: UIButton) {
        showRegistrationVC(from: viewController)
    }
    
    func loginViewController(viewController: LoginViewController, didTouchPasswordRecoveryButton sender: UIButton) {
        showPasswordRecoveryVC(from: viewController)
    }
    
    func loginViewController(withEmail email: String, password: String, viewController: LoginViewController, didTouchLoginButton sender: UIButton) {
        sender.isEnabled = false
        assembly.appAssembly.authorizationManager.login(withEmail: email,
                                                                  password: password,
                                                              successBlock: { user in
                                                                  self.delegate?.authorizationStoryWasOver(from: viewController)
                                                              },
                                                                errorBlock: { error in
                                                                    self.showInfo(to: viewController,
                                                                               title: "Error",
                                                                             message: error!.detail)
                                                                    sender.isEnabled = true
                                                                })
    }
}

extension AuthorizationRouter: RegistrationViewControllerDelegate {
    
    func registrationViewController(with email: String, name: String, password: String, viewController: RegistrationViewController, didTouchRegisterButton sender: UIButton) {
        sender.isEnabled = false
        assembly.appAssembly.authorizationManager.register(with: email,
                                                                    name: name,
                                                                password: password,
                                                            successBlock: { (_) in
                                                                self.delegate?.authorizationStoryWasOver(from: viewController)
                                                            }) { error in
                                                                self.showInfo(to: viewController,
                                                                           title: "Error",
                                                                         message: error!.detail)
                                                                sender.isEnabled = true
                                                            }
    }
}

extension AuthorizationRouter: PasswordRecoveryViewControllerDelegate {
    
    func passwordRecoveryViewController(with email: String, viewController: PasswordRecoveryViewController, didTouchRegisterButton sender: UIButton) {
        sender.isEnabled = false
        assembly.appAssembly.authorizationManager.passwordRecovery(with: email,
                                                                    successBlock: {
                                                                        viewController.navigationController?.popToRootViewController(animated: true)
                                                                    }) { error in
                                                                        self.showInfo(to: viewController,
                                                                                   title: "Error",
                                                                                 message: error!.detail)
                                                                        sender.isEnabled = true
                                                                    }
    }
}

//
//  SettingsRouter.swift
//  Messager
//
//  Created by Silchenko on 31.10.2018.
//

import UIKit

protocol SettingsRouterDelegate: class {
    
    func logoutButtonWasTapped()
}

class SettingsRouter: BaseRouter, SettingsRouterProtocol {
    
    weak var delegate: SettingsRouterDelegate?
    var assembly: SettingsAssemblyProtocol
    private var settingsViewController: SettingsViewController?
    private var backgroundChangeViewController: BackgroundChangeViewController?
    
    init(assembly: SettingsAssemblyProtocol) {
        self.assembly = assembly
    }
    
    func showInitialVC(from rootViewController: UINavigationController) {
        showSettingsViewController(from: rootViewController)
    }
    
    private func showSettingsViewController(from rootViewController: UINavigationController) {
        let vc = assembly.createSettingsViewController(user: assembly.appAssembly.authorizationManager.currentUser)
        vc.delegate = self
        settingsViewController = vc
        action(with: vc,
               from: rootViewController,
               with: .push,
           animated: true)
    }
    
    func configureSettingsViewController(with currentUser: User) {
        settingsViewController?.configure(currentUser: currentUser)
    }
}

extension SettingsRouter: SettingsViewControllerDelegate {
    
    func didChangeChatBackground(viewController: SettingsViewController) {
        let vc = assembly.createBackgroundChangeViewController()
        backgroundChangeViewController = vc
        action(with: vc,
               from: viewController,
               with: .present,
           animated: true)
    }
    
    func didTouchSaveButton(viewController: SettingsViewController, name: String?, email: String?, password: String?, currentUser: User) {
        let progress = showProgress(toViewController: viewController)
        assembly.appAssembly.apiManager.updateField(name: name,
                                                   email: email,
                                                password: password,
                                                    user: currentUser,
                                            successBlock: { user in
                                                              progress.dismiss(animated: true)
                                                              self.assembly.appAssembly.keychainManager.save(user: user)
                                                              self.showInfo(to: viewController,
                                                                         title: "Success",
                                                                       message: "Data saved!")
                                                          })
    }
    
    func settingsViewController(viewController: SettingsViewController, didChoseNewUserImage image: UIImage, currentUser: User, successBlock: @escaping (User) -> ()) {
        let progress = showProgress(toViewController: viewController)
        assembly.appAssembly.apiManager.updateImage(image: image, user: currentUser) { url in
            if let user = self.assembly.appAssembly.keychainManager.updateImage(image: url) {
                successBlock(user)
                progress.dismiss(animated: true)
                self.showInfo(to: viewController,
                           title: "Success",
                         message: "Image saved!")
            }
        }
    }
    
    func settingsViewController(viewController: SettingsViewController, didTouchLogoutButton sender: UIButton) {
        delegate?.logoutButtonWasTapped()
    }
}

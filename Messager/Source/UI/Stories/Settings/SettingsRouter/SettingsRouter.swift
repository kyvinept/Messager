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
    
    init(assembly: SettingsAssemblyProtocol) {
        self.assembly = assembly
    }
    
    func showInitialVC(from rootViewController: UINavigationController) {
        showSettingsViewController(from: rootViewController)
    }
    
    private func showSettingsViewController(from rootViewController: UINavigationController) {
        let vc = assembly.createSettingsViewController()
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
    
    func settingsViewController(viewController: SettingsViewController, didTouchLogoutButton sender: UIButton) {
        delegate?.logoutButtonWasTapped()
    }
}

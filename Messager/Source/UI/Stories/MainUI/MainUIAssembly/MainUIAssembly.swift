//
//  MainUIAssembly.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

class MainUIAssembly: MainUIAssemblyProtocol {

    var appAssembly: ApplicationAssembly
    
    init(appAssembly: ApplicationAssembly) {
        self.appAssembly = appAssembly
    }
    
    func createNavigationController(with rootViewController: UIViewController? = nil) -> UINavigationController {
        if let rootViewController = rootViewController {
            return UINavigationController(rootViewController: rootViewController)
        } else {
            return UINavigationController()
        }
    }
    
    func createTabBarController() -> UITabBarController {
        let vc = UITabBarController()
        return vc
    }
    
    func createSettingsViewController() -> SettingsViewController {
        return UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
    }
}

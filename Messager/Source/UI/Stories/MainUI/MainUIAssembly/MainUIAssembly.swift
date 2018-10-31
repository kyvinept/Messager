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
    
    func createNavigationController(with rootViewController: UIViewController) -> UINavigationController {
            return UINavigationController(rootViewController: rootViewController)
    }
    
    func createNavigationController() -> UINavigationController {
        return UINavigationController()
    }
    
    func createTabBarController() -> UITabBarController {
        let vc = UITabBarController()
        return vc
    }
}

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
    
    func createNavigationController() -> UINavigationController {
        let vc = UINavigationController()
        return vc
    }
    
    func createTabBarController() -> UITabBarController {
        let vc = UITabBarController()
        return vc
    }
}

//
//  ApplicationRouter.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

class ApplicationRouter: ApplicationRouterProtocol {
    
    var applicationAssembly: ApplicationAssembly
    var navigationController: UINavigationController!
    
    init(applicationAssembly: ApplicationAssembly) {
        self.applicationAssembly = applicationAssembly
    }
    
    func showInitialUI(forWindow window: UIWindow) {
        let navVC = UINavigationController()
        navVC.isNavigationBarHidden = true
        window.rootViewController = navVC
        self.navigationController = navVC
        
        let mainUIAssembly = MainUIAssembly(appAssembly: applicationAssembly)
        let mainUIRouter = MainUIRouter(assembly: mainUIAssembly)
        mainUIRouter.showMainUIInterfaceAfterLaunch(from: self.navigationController, animated: false)
    }
}

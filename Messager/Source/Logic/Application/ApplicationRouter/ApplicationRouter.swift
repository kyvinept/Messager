//
//  ApplicationRouter.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

class ApplicationRouter: ApplicationRouterProtocol {
    
    var applicationAssembly: ApplicationAssembly
    private var mainUIRouter: MainUIRouter?
    
    init(applicationAssembly: ApplicationAssembly) {
        self.applicationAssembly = applicationAssembly
    }
    
    func showInitialUI(forWindow window: UIWindow) {
        let vc = UINavigationController()
        window.rootViewController = vc
        
        let mainUIAssembly = MainUIAssembly(appAssembly: applicationAssembly)
        let mainUIRouter = MainUIRouter(assembly: mainUIAssembly)
        self.mainUIRouter = mainUIRouter
        mainUIRouter.showMainUIInterfaceAfterLaunch(from: vc, animated: false)
    }
}

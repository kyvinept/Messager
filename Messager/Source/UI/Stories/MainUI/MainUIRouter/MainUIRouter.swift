//
//  MainUIRouter.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

class MainUIRouter: BaseRouter, MainUIRouterProtocol {
    
    var assembly: MainUIAssembly
    
    init(assembly: MainUIAssembly) {
        self.assembly = assembly
    }
    
    func showMainUIInterfaceAfterLaunch(from viewController: UIViewController, animated: Bool) {
        let authorizationAssembly = AuthorizationAssembly(assembly: assembly)
        let authorizationRouter = AuthorizationRouter(authorizationAssembly: authorizationAssembly, rootViewController: viewController)
        authorizationRouter.showLoginVC()
    }
}

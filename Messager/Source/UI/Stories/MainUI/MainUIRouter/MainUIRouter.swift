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
        let authorizationAssembly = AuthorizationAssembly(appAssembly: assembly.appAssembly)
        let authorizationRouter = AuthorizationRouter(assembly: authorizationAssembly, rootViewController: viewController)
        authorizationRouter.showInitVC()
    }
}

//
//  MainUIRouter.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

class MainUIRouter: BaseRouter, MainUIRouterProtocol {
    
    var assembly: MainUIAssembly
    var rootViewController: UIViewController!
    
    init(assembly: MainUIAssembly) {
        self.assembly = assembly
    }
    
    func showMainUIInterfaceAfterLaunch(from rootViewController: UIViewController, animated: Bool) {
        self.rootViewController = rootViewController
        if !assembly.appAssembly.authorizationManager.isLoginUser() {
            showAuthorizationStory()
        } else {
            showChatStory()
        }
    }
    
    func showAuthorizationStory() {
        resetRootViewController()
        let authorizationAssembly = AuthorizationAssembly(appAssembly: assembly.appAssembly)
        let authorizationRouter = AuthorizationRouter(assembly: authorizationAssembly)
        authorizationRouter.delegate = self
        authorizationRouter.showInitVC(from: rootViewController)
    }
    
    func showChatStory() {
        resetRootViewController()
        let chatAssembly = ChatAssembly(appAssembly: assembly.appAssembly)
        let chatRouter = ChatRouter(assembly: chatAssembly)
        chatRouter.showInitVC(from: rootViewController)
    }
    
    private func resetRootViewController() {
        let rootVC = (rootViewController as! UINavigationController)
        if rootVC.viewControllers.count != 0 {
            rootVC.viewControllers = []
        }
    }
}

extension MainUIRouter: AuthorizationRouterDelegate {
    
    func authorizationStoryWasOver(from viewController: UIViewController) {
        showChatStory()
    }
}

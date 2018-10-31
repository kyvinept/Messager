//
//  MainUIRouter.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

class MainUIRouter: BaseRouter, MainUIRouterProtocol {

    var assembly: MainUIAssembly
    private var authorizationRouter: AuthorizationRouter?
    private var chatRouter: ChatRouter?
    private var rootViewController: UIViewController!
    private var settingsViewController: SettingsViewController!
    
    init(assembly: MainUIAssembly) {
        self.assembly = assembly
    }
    
    func showMainUIInterfaceAfterLaunch(from rootViewController: UITabBarController, animated: Bool) {
        createTabs(for: rootViewController)
        if !assembly.appAssembly.authorizationManager.isLoginUser() {
            self.rootViewController.tabBarController?.tabBar.isHidden = true
            showAuthorizationStory()
        } else {
            showChatStory()
        }
    }
    
    private func createTabs(for rootViewController: UITabBarController) {
        let navigationViewController = assembly.createNavigationController()
        navigationViewController.tabBarItem = UITabBarItem(title: "Chats",
                                                           image: UIImage(named: "mail"),
                                                   selectedImage: nil)
        self.rootViewController = navigationViewController

        self.settingsViewController = assembly.createSettingsViewController()
        let settingsViewController = assembly.createNavigationController(with: self.settingsViewController)
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings",
                                                           image: UIImage(named: "settings"),
                                                   selectedImage: nil)
        rootViewController.viewControllers = [navigationViewController, settingsViewController]
    }
    
    func showAuthorizationStory() {
        resetRootViewController()
        let authorizationAssembly = AuthorizationAssembly(appAssembly: assembly.appAssembly)
        let authorizationRouter = AuthorizationRouter(assembly: authorizationAssembly)
        authorizationRouter.delegate = self
        self.authorizationRouter = authorizationRouter
        authorizationRouter.showInitialVC(from: rootViewController)
    }
    
    func showChatStory() {
        resetRootViewController()
        let chatAssembly = ChatAssembly(appAssembly: assembly.appAssembly)
        let chatRouter = ChatRouter(assembly: chatAssembly)
        self.chatRouter = chatRouter
        chatRouter.showInitialVC(from: rootViewController)
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
        authorizationRouter = nil
        rootViewController.tabBarController?.tabBar.isHidden = false
        showChatStory()
    }
}

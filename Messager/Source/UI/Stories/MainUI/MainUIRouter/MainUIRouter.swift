//
//  MainUIRouter.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

class MainUIRouter: BaseRouter, MainUIRouterProtocol {

    var assembly: MainUIAssemblyProtocol
    private var authorizationRouter: AuthorizationRouter?
    private var settingsRouter: SettingsRouter?
    private var chatRouter: ChatRouter?
    private var chatViewController: UINavigationController!
    private var settingsViewController: UINavigationController!
    
    init(assembly: MainUIAssemblyProtocol) {
        self.assembly = assembly
    }
    
    func showMainUIInterfaceAfterLaunch(from rootViewController: UITabBarController, animated: Bool) {
        createTabs(for: rootViewController)
        if !assembly.appAssembly.authorizationManager.isLoginUser() {
            self.chatViewController.tabBarController?.tabBar.isHidden = true
            showAuthorizationStory()
        } else {
            showChatStory()
        }
    }
    
    private func createSettings() {
        let settingsAssembly = SettingsAssembly(appAssembly: assembly.appAssembly)
        settingsRouter = SettingsRouter(assembly: settingsAssembly)
        settingsRouter!.delegate = self
        settingsRouter!.showInitialVC(from: settingsViewController)
    }
    
    private func createTabs(for rootViewController: UITabBarController) {
        chatViewController = assembly.createNavigationController()
        chatViewController.tabBarItem = UITabBarItem(title: "Chats",
                                                           image: UIImage(named: "mail"),
                                                   selectedImage: nil)

        settingsViewController = assembly.createNavigationController()
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings",
                                                           image: UIImage(named: "settings"),
                                                   selectedImage: nil)
        rootViewController.viewControllers = [chatViewController, settingsViewController]
        createSettings()
    }
    
    func showAuthorizationStory() {
        resetRootViewController()
        let authorizationAssembly = AuthorizationAssembly(appAssembly: assembly.appAssembly)
        let authorizationRouter = AuthorizationRouter(assembly: authorizationAssembly)
        authorizationRouter.delegate = self
        self.authorizationRouter = authorizationRouter
        authorizationRouter.showInitialVC(from: chatViewController)
    }
    
    func showChatStory() {
        resetRootViewController()
        let chatAssembly = ChatAssembly(appAssembly: assembly.appAssembly)
        let chatRouter = ChatRouter(assembly: chatAssembly)
        self.chatRouter = chatRouter
        chatRouter.showInitialVC(from: chatViewController)
    }
    
    private func resetRootViewController() {
        let rootVC = (chatViewController as! UINavigationController)
        if rootVC.viewControllers.count != 0 {
            rootVC.viewControllers = []
        }
    }
}

extension MainUIRouter: AuthorizationRouterDelegate {
    
    func authorizationStoryWasOver(from viewController: UIViewController, currentUser: User) {
        authorizationRouter = nil
        chatViewController.tabBarController?.tabBar.isHidden = false
        settingsRouter?.configureSettingsViewController(with: currentUser)
        showChatStory()
    }
}

extension MainUIRouter: SettingsRouterDelegate {
    
    func logoutButtonWasTapped() {
        chatRouter = nil
        assembly.appAssembly.notificationManager.unregisterDevice()
        assembly.appAssembly.authorizationManager.logout()
        self.chatViewController.tabBarController?.selectedIndex = 0
        self.chatViewController.tabBarController?.tabBar.isHidden = true
        showAuthorizationStory()
    }
}

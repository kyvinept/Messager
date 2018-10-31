//
//  MainUIAssemblyProtocol.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

protocol MainUIAssemblyProtocol {
    
    var appAssembly: ApplicationAssembly { get }
    
    func createNavigationController(with rootViewController: UIViewController?) -> UINavigationController
    func createTabBarController() -> UITabBarController
    func createSettingsViewController() -> SettingsViewController
}

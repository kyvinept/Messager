//
//  SettingsRouterProtocol.swift
//  Messager
//
//  Created by Silchenko on 31.10.2018.
//

import UIKit

protocol SettingsRouterProtocol {
    
    var assembly: SettingsAssemblyProtocol { get }
    
    func showInitialVC(from rootViewController: UINavigationController)
}

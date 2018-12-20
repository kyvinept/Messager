//
//  SettingsAssemblyProtocol.swift
//  Messager
//
//  Created by Silchenko on 31.10.2018.
//

import UIKit

protocol SettingsAssemblyProtocol {
    
    var appAssembly: ApplicationAssembly { get }
    
    func createSettingsViewController(user: User?) -> SettingsViewController
    func createBackgroundChangeViewController(user: User?, withImage image: Image?) -> BackgroundChangeViewController
}

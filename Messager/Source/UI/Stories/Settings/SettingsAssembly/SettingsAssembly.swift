//
//  SettingsAssembly.swift
//  Messager
//
//  Created by Silchenko on 31.10.2018.
//

import UIKit

class SettingsAssembly: SettingsAssemblyProtocol {
    
    var appAssembly: ApplicationAssembly
    
    init(appAssembly: ApplicationAssembly) {
        self.appAssembly = appAssembly
    }
    
    func createSettingsViewController(user: User?) -> SettingsViewController {
        let vc = createStoryboard().instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        if let user = user {
            vc.configure(currentUser: user)
        }
        vc.title = "Settings"
        return vc
    }
    
    private func createStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Settings", bundle: nil)
    }
}

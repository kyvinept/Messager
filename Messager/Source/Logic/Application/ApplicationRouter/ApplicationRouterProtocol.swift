//
//  ApplicationRouterProtocol.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

protocol ApplicationRouterProtocol {
    
    var applicationAssembly: ApplicationAssembly { get }
    
    func showInitialUI(forWindow window: UIWindow)
}

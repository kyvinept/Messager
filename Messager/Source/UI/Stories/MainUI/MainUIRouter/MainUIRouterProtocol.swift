//
//  MainUIRouterProtocol.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

protocol MainUIRouterProtocol {
    
    var assembly: MainUIAssembly { get }
    
    func showMainUIInterfaceAfterLaunch(from viewController: UIViewController, animated: Bool)
}

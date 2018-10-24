//
//  ChatRouterProtocol.swift
//  Messager
//
//  Created by Silchenko on 23.10.2018.
//

import UIKit

protocol ChatRouterProtocol {
    
    var assembly: ChatAssembly { get }

    func showInitVC(from rootViewController: UIViewController)
}

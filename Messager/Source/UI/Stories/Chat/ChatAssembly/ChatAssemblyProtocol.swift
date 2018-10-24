//
//  ChatAssemblyProtocol.swift
//  Messager
//
//  Created by Silchenko on 23.10.2018.
//

import UIKit

protocol ChatAssemblyProtocol {
    
    var appAssembly: ApplicationAssembly { get }
    
    func chatVC() -> ChatViewController
    func messageVC() -> MessageViewController
}

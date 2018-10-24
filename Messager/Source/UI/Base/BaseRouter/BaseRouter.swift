//
//  BaseRouter.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

class BaseRouter {
    
    enum Action {
        case present
        case push
        case dismiss
        case pop
    }
    
    func action(with newViewController: UIViewController, from viewController: UIViewController, with action: Action, animated: Bool) {
        switch action {
        case .present:
            viewController.present(newViewController, animated: animated, completion: nil)
        case .push:
            (viewController as! UINavigationController).pushViewController(newViewController, animated: animated)
        case .dismiss:
            break
        case .pop:
            break
        }
    }
}

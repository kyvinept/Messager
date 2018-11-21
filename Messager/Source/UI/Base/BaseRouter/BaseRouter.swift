//
//  BaseRouter.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit
import JGProgressHUD

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
    
    func showInfo(to viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        viewController.present(alert,
                               animated: true,
                               completion: nil)
    }
    
    func showProgress(toViewController viewController: UIViewController) -> JGProgressHUD {
        let progress = JGProgressHUD(style: .dark)
        progress.show(in: viewController.view)
        return progress
    }
}

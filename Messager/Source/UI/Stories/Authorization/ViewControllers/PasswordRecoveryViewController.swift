//
//  PasswordRecoveryViewController.swift
//  Messager
//
//  Created by Silchenko on 23.10.2018.
//

import UIKit

protocol PasswordRecoveryViewControllerDelegate: class {
    
    func passwordRecoveryViewController(with email: String, viewController: PasswordRecoveryViewController, didTouchRegisterButton sender: UIButton)
}

class PasswordRecoveryViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    var delegate: PasswordRecoveryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func restorePasswordButtonTapped(_ sender: UIButton) {
        delegate?.passwordRecoveryViewController(with: emailTextField.text!,
                                        viewController: self,
                                didTouchRegisterButton: sender)
    }
}

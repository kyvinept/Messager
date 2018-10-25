//
//  RegistrationViewController.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

protocol RegistrationViewControllerDelegate: class {
    
    func registrationViewController(with email: String, name: String, password: String, viewController: RegistrationViewController, didTouchRegisterButton sender: UIButton)
}

class RegistrationViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    weak var delegate: RegistrationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        delegate?.registrationViewController(with: emailTextField.text!,
                                             name: nameTextField.text!,
                                         password: passwordTextField.text!,
                                   viewController: self,
                           didTouchRegisterButton: sender)
    }
}

//
//  RegistrationViewController.swift
//  Messager
//
//  Created by Silchenko on 22.10.2018.
//

import UIKit

protocol RegistrationViewControllerDelegate: class {
    
    func registerUserButtonTapped(with email: String, name: String, password: String, successBlock: @escaping (User?) -> (), errorBlock: @escaping (Fault?) -> ())
}

class RegistrationViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    var delegate: RegistrationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func registerButtonTapped(_ sender: Any) {
        delegate?.registerUserButtonTapped(with: emailTextField.text!,
                                           name: nameTextField.text!,
                                       password: passwordTextField.text!,
                                   successBlock: { _ in
                                       print("success")
                                   },
                                     errorBlock: { _ in
                                         print("error")
                                     })
    }
}

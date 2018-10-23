//
//  PasswordRecoveryViewController.swift
//  Messager
//
//  Created by Silchenko on 23.10.2018.
//

import UIKit

protocol PasswordRecoveryViewControllerDelegate: class {
    
    func passwordRecovery(with email: String, successBlock: @escaping () -> (), errorBlock: @escaping (Fault?) -> ())
}

class PasswordRecoveryViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    var delegate: PasswordRecoveryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func restorePasswordButtonTapped(_ sender: Any) {
        delegate?.passwordRecovery(with: emailTextField.text!,
                                   successBlock: {
                                       print("success")
                                   },
                                   errorBlock: { (_) in
                                       print("error")
                                   })
    }
}

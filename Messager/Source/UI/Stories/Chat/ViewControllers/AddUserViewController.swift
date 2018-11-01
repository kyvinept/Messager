//
//  AddUserViewController.swift
//  Messager
//
//  Created by Silchenko on 01.11.2018.
//

import UIKit

protocol AddUserViewControllerDelegate: class {
    
    func addUserViewController(with email: String, viewController: AddUserViewController, didTouchInputButton sender: UIButton)
    func addUserViewController(viewController: AddUserViewController, didTouchCancelButton sender: UIButton)
}

class AddUserViewController: UIViewController {
    
    weak var delegate: AddUserViewControllerDelegate?
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGesture()
    }
    
    func showError(text: String) {
        errorLabel.text = text
    }
    
    private func setGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddUserViewController.screenWasTapped(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func screenWasTapped(_ gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @IBAction func inputButtonTapped(_ sender: UIButton) {
        if emailTextField.text!.isEmpty {
            errorLabel.text = "Input email"
            return
        }
        
        delegate?.addUserViewController(with: emailTextField.text!,
                              viewController: self,
                         didTouchInputButton: sender)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        delegate?.addUserViewController(viewController: self, didTouchCancelButton: sender)
    }
}

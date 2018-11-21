//
//  SettingsViewController.swift
//  Messager
//
//  Created by Silchenko on 31.10.2018.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    
    func settingsViewController(viewController: SettingsViewController, didTouchLogoutButton sender: UIButton)
    func didTouchSaveButton(viewController: SettingsViewController, name: String?, email: String?, password: String?, currentUser: User)
    func settingsViewController(viewController: SettingsViewController, didChoseNewUserImage image: UIImage, currentUser: User, successBlock: @escaping (User) -> ())
}

class SettingsViewController: UIViewController {
    
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    weak var delegate: SettingsViewControllerDelegate?
    private var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let userImageView = userImageView, let currentUser = currentUser {
            self.setTextInTextFields()
            userImageView.downloadImage(from: currentUser.imageUrl)
        }
    }

    func configure(currentUser: User) {
        self.currentUser = currentUser
        if let userImageView = userImageView {
            userImageView.downloadImage(from: currentUser.imageUrl)
            self.setTextInTextFields()
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        delegate?.settingsViewController(viewController: self, didTouchLogoutButton: sender)
    }
    
    @IBAction func changeImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        view.endEditing(true)
        var name: String? = nil
        var email: String? = nil
        var password: String? = nil
        if let newName = nameTextField.text, newName != "" {
            name = newName
        }
        if let newEmail = emailTextField.text, newEmail != "" {
            email = newEmail
        }
        if let newPassword = passwordTextField.text, newPassword != "" {
            password = newPassword
        }
        delegate?.didTouchSaveButton(viewController: self,
                                               name: name,
                                              email: email,
                                           password: password,
                                        currentUser: currentUser!)
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        delegate?.settingsViewController(viewController: self,
                                   didChoseNewUserImage: image,
                                            currentUser: currentUser!,
                                           successBlock: { [weak self] user in
                                                             self?.currentUser = user
                                                             self?.userImageView.image = image
                                                         })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

private extension SettingsViewController {
    
    func setTextInTextFields() {
        if let currentUser = currentUser {
            idTextField.text = currentUser.id
            nameTextField.text = currentUser.name
            emailTextField.text = currentUser.email
        }
    }
    
    func setGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.viewWasTapped))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func viewWasTapped() {
        view.endEditing(true)
    }
}

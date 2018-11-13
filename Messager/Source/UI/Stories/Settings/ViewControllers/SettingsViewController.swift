//
//  SettingsViewController.swift
//  Messager
//
//  Created by Silchenko on 31.10.2018.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    
    func settingsViewController(viewController: SettingsViewController, didTouchLogoutButton sender: UIButton)
}

class SettingsViewController: UIViewController {
    
    @IBOutlet private weak var userImageView: UIImageView!
    weak var delegate: SettingsViewControllerDelegate?
    private var currentUser: User?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let userImageView = userImageView, let currentUser = currentUser {
            userImageView.downloadImage(from: currentUser.imageUrl)
        }
    }

    func configure(currentUser: User) {
        self.currentUser = currentUser
        if let userImageView = userImageView {
            userImageView.downloadImage(from: currentUser.imageUrl)
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
}

extension SettingsViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        userImageView.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

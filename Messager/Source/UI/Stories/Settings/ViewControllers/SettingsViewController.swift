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
    
    weak var delegate: SettingsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        delegate?.settingsViewController(viewController: self, didTouchLogoutButton: sender)
    }
}

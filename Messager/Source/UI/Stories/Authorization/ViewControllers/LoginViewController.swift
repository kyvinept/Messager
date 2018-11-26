 
 import UIKit
 
 protocol LoginViewControllerDelegate: class {
    
    func loginViewController(viewController: LoginViewController, didTouchRegisterButton sender: UIButton)
    func loginViewController(viewController: LoginViewController, didTouchPasswordRecoveryButton sender: UIButton)
    func loginViewController(withEmail email: String, password: String, viewController: LoginViewController, didTouchLoginButton sender: UIButton)
 }
 
 class LoginViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet weak var eyeButton: UIButton!

    weak var delegate: LoginViewControllerDelegate?
    
    @IBAction func registrationButtonTapped(_ sender: UIButton) {
        delegate?.loginViewController(viewController: self, didTouchRegisterButton: sender)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        delegate?.loginViewController(withEmail: emailTextField.text!,
                                       password: passwordTextField.text!,
                                 viewController: self,
                            didTouchLoginButton: sender)
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        delegate?.loginViewController(viewController: self, didTouchPasswordRecoveryButton: sender)
    }
    
    @IBAction func sequreButtonTapped(_ sender: Any) {
        if passwordTextField.isSecureTextEntry {
            eyeButton.imageView?.image = UIImage(named: "eye")
        } else {
            eyeButton.imageView?.image = UIImage(named: "eye-1")
        }
        passwordTextField.isSecureTextEntry.toggle()
    }
 }
                

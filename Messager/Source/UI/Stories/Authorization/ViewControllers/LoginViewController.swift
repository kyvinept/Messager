 
 import UIKit
 import FBSDKCoreKit
 import FBSDKLoginKit
 
 protocol LoginViewControllerDelegate: class {
    
    func loginViewController(viewController: LoginViewController, didTouchRegisterButton sender: UIButton)
    func loginViewController(viewController: LoginViewController, didTouchPasswordRecoveryButton sender: UIButton)
    func loginViewController(withEmail email: String, password: String, viewController: LoginViewController, didTouchLoginButton sender: UIButton)
    func didLoginFromFacebook(tokenString: String, expirationDate: Date, viewController: LoginViewController)
 }
 
 class LoginViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var eyeButton: UIButton!
    @IBOutlet private weak var facebookLoginButton: FBSDKLoginButton!
    
    weak var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        facebookLoginButton.readPermissions = ["public_profile", "email"]
        facebookLoginButton.delegate = self
    }
    
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
            eyeButton.setImage(UIImage(named: "eyeBlue"), for: .normal)
        } else {
            eyeButton.setImage(UIImage(named: "eyeBlack"), for: .normal)
        }
        passwordTextField.isSecureTextEntry.toggle()
    }
 }
                
 extension LoginViewController: FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        guard !result.isCancelled else { return }
        delegate?.didLoginFromFacebook(tokenString: result.token.tokenString,
                                    expirationDate: result.token.expirationDate,
                                    viewController: self)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Log out")
    }
 }

 
 import UIKit
 
 protocol LoginViewControllerDelegate: class {
    
    func loginViewController(viewController: LoginViewController, didTouchRegisterButton sender: UIButton)
    func loginViewController(viewController: LoginViewController, didTouchPasswordRecoveryButton sender: UIButton)
    func loginViewController(withEmail email: String, password: String, viewController: LoginViewController, didTouchLoginButton sender: UIButton)
 }
 
 class LoginViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    
    
    
    
    
    
    
    
    
    
    var dataStore: IDataStore?
    var testObject: [String : Any]?
    
    func showErrorAlert(_ fault: Fault) {
        let alert = UIAlertController(title: String(format: "Error %@", fault.faultCode), message: fault.message, preferredStyle: .alert)
        let dismissButton = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(dismissButton)
        present(alert, animated: true, completion: nil)
    }
    
    func saveTestObject() {
        dataStore = Backendless.sharedInstance().data.ofTable("TestTable")
        testObject = ["foo" : "Hello World"]
        dataStore?.save(testObject, response: { savedTestObject in
            if let savedObject = savedTestObject as? [String : Any] {
//                DispatchQueue.main.async {
//                    self.objectSavedLabel.text = "Object has been saved in the real-time database"
//                    self.liveUpdateObjectPropertyLabel.text = "Live update object property"
//                    self.propertyLabel.text = savedObject["foo"] as? String
//                }
                self.testObject = savedObject
                let eventHandler = self.dataStore?.rt
                if let savedObjectId = savedObject["objectId"] as? String {
                    let whereClause = String(format: "objectId = '%@'", savedObjectId)
                    eventHandler?.addUpdateListener(whereClause, response: { updatedTestObject in
                        if let updatedObject = updatedTestObject as? [String : Any] {
                            if (updatedObject["foo"] != nil) {
//                                self.propertyLabel.text = updatedObject["foo"] as? String
                            }
                        }
                    }, error: { fault in
                        self.showErrorAlert(fault!)
                    })
                }
            }
        }, error: { fault in
            self.showErrorAlert(fault!)
        })
    }
    
//    @IBAction func pressedUpdate(_ sender: Any) {
//        if let property = changePropertyValueTextField.text {
//            testObject!["foo"] = property
//            dataStore?.save(testObject, response: { updatedTestObject in
//            }, error: { fault in
//                self.showErrorAlert(fault!)
//            })
//        }
//        changePropertyValueTextField.text = ""
//        updateButton.isEnabled = false
//    }
 }
                

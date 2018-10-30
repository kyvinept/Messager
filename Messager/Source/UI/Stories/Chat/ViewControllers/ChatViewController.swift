//
//  ChatViewController.swift
//  Messager
//
//  Created by Silchenko on 23.10.2018.
//

import UIKit


protocol ChatViewControllerDelegate: class {
    
    func didTouchSendMessageButton(with message: Message, toUser: User, viewController: ChatViewController)
    func didTouchBackButton(viewController: ChatViewController)
}

class ChatViewController: UIViewController {

    @IBOutlet private weak var sendMessageButton: UIButton!
    @IBOutlet private weak var cameraButton: UIButton!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var getFileButton: UIButton!
    @IBOutlet private weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var sendMessageButtonLeftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var messages: [Message] = []
    private var currentUser: User!
    private var toUser: User!
    
    weak var delegate: ChatViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        addNotification()
        addGesture()
        sendMessageButton.alpha = 0
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
    }

    func configure(with currentUser: User, toUser: User) {
        self.currentUser = currentUser
        self.toUser = toUser
    }

    func showNewMessage(_ message: String) {
        
    }
    
    @IBAction func getFileButtonTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }
}

extension ChatViewController {
    
    private func insertNewMessage(_ message: Message) {
        messages.append(message)
        collectionView.reloadData()
        collectionView.scrollToBottom(animated: true)
    }
}

extension ChatViewController {
    
    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func viewWasTapped(_ gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

extension ChatViewController {
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            textViewBottomConstraint.constant = -(keyboardSize.height - self.view.safeAreaInsets.bottom)
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        textViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

extension ChatViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.text = "Input text..."
        textView.textColor = UIColor.lightGray
        textViewNoText()
    }
    
    func textViewDidChange(_ textViewf: UITextView) {
        if textView.text.isEmpty {
            textViewNoText()
        } else {
            newTextInTextView()
        }
    }
    
    private func textViewNoText() {
        sendMessageButtonLeftConstraint.constant = 48
        UIView.animate(withDuration: 0.4) {
            self.cameraButton.alpha = 1
            self.getFileButton.alpha = 1
            self.sendMessageButton.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func newTextInTextView() {
        sendMessageButtonLeftConstraint.constant = 12
        UIView.animate(withDuration: 0.4) {
            self.cameraButton.alpha = 0
            self.getFileButton.alpha = 0
            self.sendMessageButton.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageSize = image.preferredPresentationSizeForItemProvider
       
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath)
        return cell
    }
}

//
//  ChatViewController.swift
//  Messager
//
//  Created by Silchenko on 23.10.2018.
//

import UIKit
import MessageKit
import Photos
import Chatto

protocol ChatViewControllerDelegate: class {
    
    func didTouchSendMessageButton(with message: Message, toUser: User, viewController: ChatViewController)
    func didTouchBackButton(viewController: ChatViewController)
}

class ChatViewController: MessagesViewController {

    private var messages: [Message] = []
    private var createPhotoButton: InputBarButtonItem!
    private var choseFileButton: InputBarButtonItem!
    private var currentUser: User!
    private var toUser: User!
    private let widthButton: CGFloat = 35
    private let heightButton: CGFloat = 30
    private let horizontalOffset: CGFloat = 50
    
    weak var delegate: ChatViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        createRightButtons()
        configureSendButton()
        setConstraintsForRightButtons()
        setNotification()
        createBackButton()
        addGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureStyleInputBar()
        messagesCollectionView.contentInset.bottom = messageInputBar.frame.height
        messagesCollectionView.scrollIndicatorInsets.bottom = messageInputBar.frame.height
    }

    func configure(with currentUser: User, toUser: User) {
        self.currentUser = currentUser
        self.toUser = toUser
    }

    func showNewMessage(_ message: String) {
        let newMessage = Message(sender: Sender(id: toUser.id, displayName: toUser.name),
                              messageId: String(messages.count+1),
                               sentDate: Date(),
                                   kind: .text(message))
        insertNewMessage(newMessage)
    }

    private func setDelegate() {
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }

    private func insertNewMessage(_ message: Message) {
        messages.append(message)
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToBottom(animated: true)
    }

    @objc private func cameraButtonPressed() {
        let picker = UIImagePickerController()
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }

    @objc private func chosePhotoButtonPressed() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
}

extension ChatViewController {

    private func createBackButton() {
        let backButton = UIBarButtonItem(title: "< to Users",
                                         style: .plain,
                                        target: self,
                                        action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }

    @objc func backButtonTapped() {
        delegate?.didTouchBackButton(viewController: self)
    }

    private func addGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(messagesCollectionViewWasTapped(_:)))
        messagesCollectionView.addGestureRecognizer(gesture)
    }

    @objc private func messagesCollectionViewWasTapped(_ gesture: UITapGestureRecognizer){
        hideKeyboard()
    }

    private func hideKeyboard() {
        messageInputBar.inputTextView.resignFirstResponder()
        messageInputBar.inputTextView.endEditing(true)
    }

    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }

    @objc func keyBoardWillShow(notification: NSNotification) {
        messagesCollectionView.scrollToBottom()
    }

    @objc func keyBoardWillHide(notification: NSNotification) {
        messageInputBar.inputTextView.text = ""
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        hideKeyboard()
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageSize = image.preferredPresentationSizeForItemProvider
        
        var size: CGSize
        if imageSize.height > imageSize.width {
            size = CGSize(width: self.view.frame.width*0.5, height: imageSize.height/imageSize.width*self.view.frame.width*0.5)
        } else {
            size = CGSize(width: self.view.frame.width*0.8, height: imageSize.height/imageSize.width*self.view.frame.width*0.8)
        }
        
        let mediaItem = ImageMessage(url: nil,
                                   image: image,
                        placeholderImage: UIImage(named: "backgroundMessage")!,
                                    size: size)
        let message = Message(sender: Sender(id: currentUser.id, displayName: currentUser.name),
                           messageId: String(messages.count+1),
                            sentDate: Date(),
                                kind: MessageKind.photo(mediaItem))
        insertNewMessage(message)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        hideKeyboard()
    }
}

extension ChatViewController {

    private func configureStyleInputBar() {
        messageInputBar.inputTextView.placeholder = "Input message..."
        let backgroundView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                              width: self.view.frame.width,
                                             height: self.view.frame.height))
        backgroundView.backgroundColor = UIColor(red: 245/255.0,
                                               green: 222/255.0,
                                                blue: 179/255.0,
                                               alpha: 1)
        messageInputBar.backgroundView.addSubview(backgroundView)
    }
    
    private func configureSendButton() {
        messageInputBar.sendButton.image = UIImage(named: "send")
        messageInputBar.sendButton.title = ""
    }

    private func createRightButtons() {
        createPhotoButton = InputBarButtonItem(type: .system)
        createPhotoButton.tintColor = .gray
        createPhotoButton.image = UIImage(named: "photo-camera")
        createPhotoButton.addTarget(self, action: #selector(cameraButtonPressed), for: .primaryActionTriggered)
        createPhotoButton.setSize(CGSize(width: widthButton, height: heightButton), animated: false)

        choseFileButton = InputBarButtonItem(type: .system)
        choseFileButton.tintColor = .gray
        choseFileButton.image = UIImage(named: "clip")
        choseFileButton.addTarget(self, action: #selector(chosePhotoButtonPressed), for: .primaryActionTriggered)
        choseFileButton.setSize(CGSize(width: widthButton, height: heightButton), animated: false)
    }

    private func setConstraintsForRightButtons() {
        messageInputBar.rightStackView.alignment = .center
        messageInputBar.setRightStackViewWidthConstant(to: horizontalOffset, animated: false)

        messageInputBar.rightStackView.alignment = .center
        messageInputBar.setRightStackViewWidthConstant(to: horizontalOffset + widthButton, animated: false)
        messageInputBar.setStackViewItems([choseFileButton, createPhotoButton], forStack: .right, animated: false)
    }

    private func setConstraintsForSendButton() {
        messageInputBar.rightStackView.alignment = .center
        messageInputBar.setRightStackViewWidthConstant(to: horizontalOffset, animated: false)
        messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
    }
}

extension ChatViewController: MessagesDataSource {

    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.image = UIImage(named: "person")
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> Sender {
        return Sender(id: currentUser.id, displayName: currentUser.name)
    }

    func messageForItem(at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }

    func cellTopLabelAttributedText(for message: MessageType,
                                    at indexPath: IndexPath) -> NSAttributedString? {

        let name = message.sender.displayName
        return NSAttributedString(
            string: name,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor(white: 0.3, alpha: 1)
            ]
        )
    }
}

extension ChatViewController: MessagesLayoutDelegate {

    func avatarSize(for message: MessageType, at indexPath: IndexPath,
                    in messagesCollectionView: MessagesCollectionView) -> CGSize {

        return .zero
    }

    func heightForLocation(message: MessageType, at indexPath: IndexPath,
                           with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
}

extension ChatViewController: MessagesDisplayDelegate {

    func backgroundColor(for message: MessageType, at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return isFromCurrentSender(message: message) ? .blue : .gray
    }

    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath,
                             in messagesCollectionView: MessagesCollectionView) -> Bool {

        return false
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft

        return .bubbleTail(corner, .curved)
    }
}

extension ChatViewController: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        let message = Message(sender: Sender(id: currentUser.id, displayName: currentUser.name),
                           messageId: String(messages.count + 1),
                            sentDate: Date(),
                                kind: .text(text.trimmingCharacters(in: .whitespacesAndNewlines)))
        insertNewMessage(message)
        inputBar.inputTextView.text = ""
        delegate?.didTouchSendMessageButton(with: message,
                                          toUser: toUser,
                                  viewController: self)
    }

    func messageInputBar(_ inputBar: MessageInputBar, textViewTextDidChangeTo text: String) {
        if !text.isEmpty {
            setConstraintsForSendButton()
        } else {
            setConstraintsForRightButtons()
        }
    }
}

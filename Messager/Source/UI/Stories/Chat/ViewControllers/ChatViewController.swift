//
//  ChatViewController.swift
//  Messager
//
//  Created by Silchenko on 23.10.2018.
//

import UIKit
import MessageKit
import Photos

class ChatViewController: MessagesViewController {
    
    private var messages: [Message] = []
    private var camera: InputBarButtonItem!
    private var file: InputBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        createRightButtons()
        configureSendButton()
        setConstraintsForRightButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureStyleInputBar()
    }
    
    private func setDelegate() {
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    private func insertNewMessage(_ message: Message) {
        messages.append(message)
        messagesCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
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
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageSize = image.preferredPresentationSizeForItemProvider
        let size = CGSize(width: self.view.frame.width*0.6, height: imageSize.height/imageSize.width*self.view.frame.width*0.6)
        let mediaItem = ImageMessage(url: nil, image: image, placeholderImage: UIImage(named: "backendlessLogo")!, size: size)
        let message = Message(sender: Sender(id: "1", displayName: "Name"), messageId: "1", sentDate: Date(), kind: MessageKind.photo(mediaItem))
        insertNewMessage(message)
    }
}

extension ChatViewController {

    private func configureStyleInputBar() {
        messageInputBar.inputTextView.placeholder = "Input message..."
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        backgroundView.backgroundColor = UIColor(red: 245/255.0, green: 222/255.0, blue: 179/255.0, alpha: 1)
        messageInputBar.backgroundView.addSubview(backgroundView)
    }
    
    private func configureSendButton() {
        messageInputBar.sendButton.image = UIImage(named: "send")
        messageInputBar.sendButton.title = ""
    }
    
    private func createRightButtons() {
        camera = InputBarButtonItem(type: .system)
        camera.tintColor = .gray
        camera.image = UIImage(named: "photo-camera")
        camera.addTarget(self, action: #selector(cameraButtonPressed), for: .primaryActionTriggered)
        camera.setSize(CGSize(width: 30, height: 30), animated: false)
        
        file = InputBarButtonItem(type: .system)
        file.tintColor = .gray
        file.image = UIImage(named: "clip")
        file.addTarget(self, action: #selector(cameraButtonPressed), for: .primaryActionTriggered)
        file.setSize(CGSize(width: 40, height: 30), animated: false)
    }
    
    private func setConstraintsForRightButtons() {
        messageInputBar.rightStackView.alignment = .center
        messageInputBar.setRightStackViewWidthConstant(to: 50, animated: false)
        
        messageInputBar.rightStackView.alignment = .center
        messageInputBar.setRightStackViewWidthConstant(to: 80, animated: false)
        messageInputBar.setStackViewItems([file, camera], forStack: .right, animated: false)
    }
    
    private func setConstraintsForSendButton() {
        messageInputBar.rightStackView.alignment = .center
        messageInputBar.setRightStackViewWidthConstant(to: 50, animated: false)
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
        return Sender(id: "1", displayName: "Name")
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
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> CGSize {
        
        return CGSize(width: 0, height: 8)
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
        let message = Message(sender: Sender(id: "1", displayName: "User"), messageId: "1", sentDate: Date(), kind: .text(text))
        insertNewMessage(message)
        inputBar.inputTextView.text = ""
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, textViewTextDidChangeTo text: String) {
        if text != "" {
            setConstraintsForSendButton()
        } else {
            setConstraintsForRightButtons()
        }
    }
}

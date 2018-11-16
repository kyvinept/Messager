//
//  ChatViewController.swift
//  Messager
//
//  Created by Silchenko on 23.10.2018.
//

import UIKit
import JGProgressHUD
import AVFoundation

protocol ChatViewControllerDelegate: class {
    
    func didTouchSendMessageButton(with message: Message, toUser: User, viewController: ChatViewController)
    func didTouchBackButton(viewController: ChatViewController)
    func didTouchGetCurrentLocation(viewController: ChatViewController)
    func didTappedLocationCell(withLocation location: CLLocationCoordinate2D, viewController: ChatViewController)
    func didTouchChoseLocation(viewController: ChatViewController)
    func didTappedGiphyButton(viewController: ChatViewController)
}

class ChatViewController: UIViewController {

    @IBOutlet private weak var sendMessageButton: UIButton!
    @IBOutlet private weak var cameraButton: UIButton!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var getFileButton: UIButton!
    @IBOutlet private weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var sendMessageButtonLeftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noMassageLabel: UILabel!
    @IBOutlet private weak var giphyView: UIView!
    @IBOutlet private weak var bottomGiphyViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var giphyViewHeight: NSLayoutConstraint!
    
    private var giphyViewController: GiphyViewController!
    private var progress: JGProgressHUD?
    private var messages = [Message]()
    private var currentUser: User!
    private var toUser: User!
    
    weak var delegate: ChatViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        createBackButton()
        registerCell()
        addNotification()
        addGesture()
        setBaseUIComponents()
        setActivityIndicator()
        addGiphyViewController(giphyViewController)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.scrollToBottom(animated: false)
        if !messages.isEmpty {
            self.noMassageLabel.isHidden = true
        }
    }

    func configure(with currentUser: User, toUser: User, messages: [Message], giphyViewController: GiphyViewController) {
        self.currentUser = currentUser
        self.toUser = toUser
        self.messages = messages
        self.giphyViewController = giphyViewController
    }

    func showNewMessage(_ message: Message) {
        if !self.messages.contains(where: { $0 == message } ) {
            insertNewMessage(message)
        }
    }
    
    func newMessage(withLocation location: CLLocationCoordinate2D) {
        let message = Message(sender: currentUser, messageId: String(messages.count+1), sentDate: Date(), kind: .location(location))
        delegate?.didTouchSendMessageButton(with: message, toUser: toUser, viewController: self)
        insertNewMessage(message)
    }
        
    func update(message: Message) {
        let oldMessage = messages.first { $0 == message }
        if let oldMessage = oldMessage {
            switch oldMessage.kind {
            case .photo(let mediaItem):
                mediaItem.downloaded = true
            default:
                break
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.scrollToBottom(animated: true)
        }
    }
    
    func stopActivityIndicator() {
        progress?.dismiss()
    }
    
    @IBAction func giphyButtonTapped(_ sender: Any) {
        delegate?.didTappedGiphyButton(viewController: self)
        removeNotification()
        self.view.endEditing(true)
        bottomGiphyViewConstraint.constant = 0
        textViewBottomConstraint.constant = -giphyViewHeight.constant
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            self.tableView.scrollToBottom(animated: true)
        }
        addNotification()
    }
    
    private func setBaseUIComponents() {
        sendMessageButton.alpha = 0
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setActivityIndicator() {
        progress = JGProgressHUD(style: .dark)
        progress?.show(in: self.view)
    }
    
    private func addGiphyViewController(_ viewController: GiphyViewController) {
        self.addChildViewController(viewController)
        giphyView.addSubview(viewController.view)
        
        giphyView.addConstraint(NSLayoutConstraint(item: viewController.view, attribute: .bottom, relatedBy: .equal, toItem: giphyView, attribute: .bottom, multiplier: 1, constant: 0))
        giphyView.addConstraint(NSLayoutConstraint(item: viewController.view, attribute: .left, relatedBy: .equal, toItem: giphyView, attribute: .left, multiplier: 1, constant: 0))
        giphyView.addConstraint(NSLayoutConstraint(item: viewController.view, attribute: .right, relatedBy: .equal, toItem: giphyView, attribute: .right, multiplier: 1, constant: 0))
        giphyView.addConstraint(NSLayoutConstraint(item: viewController.view, attribute: .top, relatedBy: .equal, toItem: giphyView, attribute: .top, multiplier: 1, constant: 0))
    }
    
    private func createBackButton() {
        let back = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(ChatViewController.backButtonTapped))
        self.navigationItem.leftBarButtonItem = back
    }
    
    @objc func backButtonTapped() {
        delegate?.didTouchBackButton(viewController: self)
    }
    
    @IBAction func getFileButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: nil,
                                    message: nil,
                             preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Video",
                                      style: .default,
                                    handler: { _ in
                                                 let video = UIImagePickerController()
                                                 video.delegate = self
                                                 video.sourceType = .photoLibrary
                                                 video.mediaTypes = ["public.movie"]
                                                 self.present(video,
                                                              animated: true,
                                                            completion: nil)
                                             }))
        alert.addAction(UIAlertAction(title: "Gallery",
                                      style: .default,
                                    handler: { _ in
                                                 let gallary = UIImagePickerController()
                                                 gallary.delegate = self
                                                 gallary.sourceType = .photoLibrary
                                                 gallary.mediaTypes = ["public.image"]
                                                 self.present(gallary,
                                                              animated: true,
                                                              completion: nil)
                                             }))
        alert.addAction(UIAlertAction(title: "Location",
                                      style: .default,
                                    handler: { _ in
                                                 self.getLocation()
                                             }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                    handler: nil))
        self.present(alert,
                     animated: true,
                   completion: nil)
    }
    
    private func getLocation() {
        let alert = UIAlertController(title: nil,
                                    message: nil,
                             preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Current location",
                                      style: .default,
                                    handler: { _ in
                                                 self.delegate?.didTouchGetCurrentLocation(viewController: self)
                                             }))
        alert.addAction(UIAlertAction(title: "Chose location",
                                      style: .default,
                                    handler: { _ in
                                                 self.delegate?.didTouchChoseLocation(viewController: self)
                                             }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                    handler: nil))
        self.present(alert,
                     animated: true,
                   completion: nil)
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
    
    @IBAction func sendMessageButtonTapped(_ sender: Any) {
        let message = Message(sender: currentUser,
                             messageId: String(messages.count+1),
                             sentDate: Date(),
                             kind: MessageKind.text(textView.text.trimmingCharacters(in: .whitespacesAndNewlines)))
        insertNewMessage(message)
        delegate?.didTouchSendMessageButton(with: message,
                                          toUser: toUser,
                                  viewController: self)
        textView.text = ""
        self.view.endEditing(true)
    }
}

extension ChatViewController {
    
    private func insertNewMessage(_ message: Message) {
        messages.append(message)
        messages.sort { $0.sentDate < $1.sentDate }
        
        DispatchQueue.main.async {
            if !self.noMassageLabel.isHidden {
                self.noMassageLabel.isHidden = true
            }
            self.tableView.reloadData()
            self.tableView.scrollToBottom(animated: true)
        }
    }
}

extension ChatViewController {
    
    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func viewWasTapped(_ gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
        bottomGiphyViewConstraint.constant = -giphyViewHeight.constant*2
        textViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
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
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            giphyViewHeight.constant = (keyboardSize.height - self.view.safeAreaInsets.bottom)
            bottomGiphyViewConstraint.constant = -giphyViewHeight.constant*2
            textViewBottomConstraint.constant = -(keyboardSize.height - self.view.safeAreaInsets.bottom)
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.tableView.scrollToBottom(animated: true)
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        textViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            self.tableView.scrollToBottom(animated: true)
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
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let size = image.getSizeForMessage()
            
            let message = Message(sender: currentUser!,
                               messageId: String(messages.count+1),
                                sentDate: Date(),
                                    kind: MessageKind.photo(MediaItem(image: image,
                                                                       size: size,
                                                                 downloaded: false)))
            insertNewMessage(message)
            delegate?.didTouchSendMessageButton(with: message,
                                              toUser: toUser,
                                      viewController: self)
        } else if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
            let message = Message(sender: currentUser!,
                               messageId: String(messages.count+1),
                                sentDate: Date(),
                                    kind: MessageKind.video(VideoItem(videoUrl: videoUrl, downloaded: false)))
            insertNewMessage(message)
            delegate?.didTouchSendMessageButton(with: message,
                                              toUser: toUser,
                                      viewController: self)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch messages[indexPath.row].kind {
        case .text(let text):
            
            if messages[indexPath.row].sender == currentUser! {
                tableView.register(UINib(nibName: "OutgoingMessageCell", bundle: nil), forCellReuseIdentifier: "TextCell")
                let cell = tableView.dequeueReusableCell(withIdentifier: "OutgoingMessageCell", for: indexPath) as! OutgoingMessageCell
                cell.configure(model: MessageCellViewModel(message: text,
                                                              date: messages[indexPath.row].sentDate,
                                                      userImageUrl: messages[indexPath.row].sender.imageUrl))
                return cell
            } else {
                tableView.register(UINib(nibName: "IncomingMessageCell", bundle: nil), forCellReuseIdentifier: "TextCell")
                let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingMessageCell", for: indexPath) as! IncomingMessageCell
                cell.configure(model: MessageCellViewModel(message: text,
                                                              date: messages[indexPath.row].sentDate,
                                                      userImageUrl: messages[indexPath.row].sender.imageUrl))
                return cell
            }
            
        case .photo(let mediaItem):
            
            if messages[indexPath.row].sender == currentUser! {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OutgoingImageCell", for: indexPath) as! OutgoingImageCell
                cell.configure(model: ImageCellViewModel(image: mediaItem.image,
                                                     imageSize: mediaItem.size,
                                                          date: messages[indexPath.row].sentDate,
                                                    downloaded: mediaItem.downloaded,
                                                  userImageUrl: messages[indexPath.row].sender.imageUrl))
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingImageCell", for: indexPath) as! IncomingImageCell
                cell.configure(model: ImageCellViewModel(image: mediaItem.image,
                                                     imageSize: mediaItem.size,
                                                          date: messages[indexPath.row].sentDate,
                                                    downloaded: true,
                                                  userImageUrl: messages[indexPath.row].sender.imageUrl))
                return cell
            }
            
        case .location(let location):
            
            if messages[indexPath.row].sender == currentUser! {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OutgoingLocationCell", for: indexPath) as! OutgoingLocationCell
                cell.configure(model: LocationCellViewModel(date: messages[indexPath.row].sentDate,
                                                    userImageUrl: messages[indexPath.row].sender.imageUrl,
                                                        location: location,
                                                         tapCell: { [weak self] coordinate in
                                                                      self?.didTappedCell(location: coordinate)
                                                                  }))
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingLocationCell", for: indexPath) as! IncomingLocationCell
                cell.configure(model: LocationCellViewModel(date: messages[indexPath.row].sentDate,
                                                    userImageUrl: messages[indexPath.row].sender.imageUrl,
                                                        location: location,
                                                         tapCell: { [weak self] coordinate in
                                                                      self?.didTappedCell(location: coordinate)
                                                                  }))
                return cell
            }
            
        case .video(let videoItem):
            
            if messages[indexPath.row].sender == currentUser! {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OutgoingVideoCell", for: indexPath) as! OutgoingVideoCell
                cell.configure(model: VideoCellViewModel(date: messages[indexPath.row].sentDate,
                                                 userImageUrl: messages[indexPath.row].sender.imageUrl,
                                                        video: videoItem.videoUrl,
                                                   downloaded: videoItem.downloaded))
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingVideoCell", for: indexPath) as! IncomingVideoCell
                cell.configure(model: VideoCellViewModel(date: messages[indexPath.row].sentDate,
                                                 userImageUrl: messages[indexPath.row].sender.imageUrl,
                                                        video: videoItem.videoUrl,
                                                   downloaded: true))
                return cell
            }
        }
    }
    
    private func didTappedCell(location: CLLocationCoordinate2D) {
        delegate?.didTappedLocationCell(withLocation: location, viewController: self)
    }
    
    private func registerCell() {
        tableView.register(UINib(nibName: "OutgoingMessageCell", bundle: nil), forCellReuseIdentifier: "OutgoingMessageCell")
        tableView.register(UINib(nibName: "IncomingMessageCell", bundle: nil), forCellReuseIdentifier: "IncomingMessageCell")
        tableView.register(UINib(nibName: "OutgoingImageCell", bundle: nil), forCellReuseIdentifier: "OutgoingImageCell")
        tableView.register(UINib(nibName: "IncomingImageCell", bundle: nil), forCellReuseIdentifier: "IncomingImageCell")
        tableView.register(UINib(nibName: "OutgoingLocationCell", bundle: nil), forCellReuseIdentifier: "OutgoingLocationCell")
        tableView.register(UINib(nibName: "IncomingLocationCell", bundle: nil), forCellReuseIdentifier: "IncomingLocationCell")
        tableView.register(UINib(nibName: "OutgoingVideoCell", bundle: nil), forCellReuseIdentifier: "OutgoingVideoCell")
        tableView.register(UINib(nibName: "IncomingVideoCell", bundle: nil), forCellReuseIdentifier: "IncomingVideoCell")
    }
}

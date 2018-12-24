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
    func didTappedSearchGiphyButton(search: String, pageNumber: Int, viewController: ChatViewController, successBlock: @escaping ([Giphy]) -> ())
    func didTappedRemoveMessageButton(message: Message, toUser: User, viewController: ChatViewController)
    func didTouchPreviewGiphy(url: String, viewController: ChatViewController)
    func didTouchEndPreviewGiphy(viewController: ChatViewController)
    func didEditTextMessage(message: Message, toUser: User, viewController: ChatViewController)
    func didTappedCalendarButton(viewController: ChatViewController)
}

class ChatViewController: UIViewController {

    @IBOutlet private weak var bottomView: UIView!
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
    @IBOutlet private weak var giphyButton: UIButton!
    @IBOutlet private weak var searchGiphyButtonLeftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var searchGiphyButton: UIButton!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var backgroundViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var answerView: AnswerView!
    
    private var searchView: SearchView?
    private var isGiphyInput = false
    private var giphyViewController: GiphyViewController!
    private var messages = [Message]() {
        didSet {
            if let dataSource = dataSource {
                dataSource.messages = messages
            }
        }
    }
    private var currentUser: User!
    private var toUser: User!
    private var editingMessage: Message?
    private var searchMessageIndex: Int?
    private var dataSource: ChatViewDataSource!
    private var searchGiphyPlaceholder = "Search giphy..."
    private var searchTextPlaceholder = "Search text..."
    private var inputTextPlaceholder = "Input text..."
    private var defaultStateGiphyImage = UIImage(named: "happiness")
    private var activeStateGiphyImage = UIImage(named: "smiling")
    private var calendarIcon = UIImage(named: "calendar")
    private var searchToTopIcon = UIImage(named: "top")
    private var searchToBottomIcon = UIImage(named: "down")
    private var rowBuilder: ChatViewRowBuilder!
    private var isAnswer = false {
        didSet {
            answerView.isHidden = !isAnswer
        }
    }
    
    weak var delegate: ChatViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        createBackButton()
        addNotification()
        setBaseUIComponents()
        addGiphyViewController(giphyViewController)
        addSearchButton()
        initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.scrollToBottom(animated: false, withReload: false)
    }
    
    func updateMessages() {
        dataSource.reloadData()
    }
    
    func setBackground(image: UIImage) {
        backgroundImageView.image = image
        
        let size = image.getSizeForMessage()
        backgroundViewWidthConstraint.constant = size.width / size.height * view.frame.height
    }
    
    func searchMessages(byDate date: Date) {
        let messagesForDay = messages.filter { date.toString(dateFormat: "yyyy-MM-dd") == $0.sentDate.toString(dateFormat: "yyyy-MM-dd") }
        searchView?.set(messages: messagesForDay)
    }

    func configure(with currentUser: User, toUser: User, messages: [Message], giphyViewController: GiphyViewController) {
        self.currentUser = currentUser
        self.toUser = toUser
        self.messages = messages.sorted { $0.sentDate.toString(dateFormat: "yyyy-MM-dd hh:mm:ss") < $1.sentDate.toString(dateFormat: "yyyy-MM-dd hh:mm:ss") }
        self.giphyViewController = giphyViewController
        
        giphyViewController.choseGiphy = {[weak self] giphy in
            if let self = self {
                let message = Message(sender: self.currentUser,
                                      answer: nil,
                                   messageId: UUID().uuidString,
                                    sentDate: Date(),
                                        kind: MessageKind.giphy(giphy))
                self.insertNewMessage(message)
            }
        }
        giphyViewController.previewGiphy = { [weak self] url in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.didTouchPreviewGiphy(url: url, viewController: strongSelf)
        }
        giphyViewController.endPreviewGiphy = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.didTouchEndPreviewGiphy(viewController: strongSelf)
        }
    }

    func showNewMessage(_ message: Message) {
        if !self.messages.contains(where: { $0 == message } ) {
            insertNewMessage(message)
            toUser.messages.append(message)
        }
    }
    
    func newMessage(withLocation location: CLLocationCoordinate2D) {
        let message = Message(sender: currentUser,
                              answer: nil,
                           messageId: UUID().uuidString,
                            sentDate: Date(),
                                kind: .location(location))
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
            self.dataSource.scrollToBottom(animated: true, withReload: true)
        }
    }
    
    @IBAction func giphyButtonTapped(_ sender: Any) {
        view.endEditing(true)
        if isGiphyInput {
            isGiphyInput.toggle()
            textView.text = inputTextPlaceholder
            giphyButton.setImage(defaultStateGiphyImage, for: .normal)
            bottomGiphyViewConstraint.constant = -giphyViewHeight.constant*2
            textViewBottomConstraint.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        } else {
            textView.text = searchGiphyPlaceholder
            giphyButton.setImage(activeStateGiphyImage, for: .normal)
            isGiphyInput.toggle()
            removeNotification()
            bottomGiphyViewConstraint.constant = -view.safeAreaInsets.bottom
            textViewBottomConstraint.constant = -giphyViewHeight.constant + view.safeAreaInsets.bottom
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.dataSource.scrollToBottom(animated: true, withReload: false)
            }
            addNotification()
        }
    }
    
    private func setBaseUIComponents() {
        sendMessageButton.alpha = 0
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        isAnswer = false
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
        if let editingMessage = editingMessage {
            editingMessage.kind = .text(textView.text)
            delegate?.didEditTextMessage(message: editingMessage, toUser: toUser, viewController: self)
            self.editingMessage = nil
            hideKeyboard()
            dataSource.reloadData()
        }
        else {
            let message = Message(sender: currentUser,
                                  answer: nil,
                               messageId: UUID().uuidString,
                                sentDate: Date(),
                                    kind: MessageKind.text(textView.text.trimmingCharacters(in: .whitespacesAndNewlines)))
            insertNewMessage(message)
            hideKeyboard()
        }
    }
    
    private func hideKeyboard() {
        bottomGiphyViewConstraint.constant = -giphyViewHeight.constant*2
        textViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        self.view.endEditing(true)
    }
    
    @IBAction func searchGiphyButtonTapped(_ sender: UIButton) {
        let text = textView.text!
        view.endEditing(true)
        delegate?.didTappedSearchGiphyButton(search: text,
                                         pageNumber: giphyViewController.pageNumber,
                                     viewController: self,
                                       successBlock: { giphy in
                                                          self.bottomGiphyViewConstraint.constant = 0
                                                          self.giphyViewController.configure(giphy: giphy)
                                                     })
    }
}

private extension ChatViewController {
    
    func initTableView() {
        rowBuilder = ChatViewRowBuilder(tableView: tableView)
        dataSource = ChatViewDataSource(tableView: tableView, rowBuilder: rowBuilder)
        dataSource.currentUser = currentUser
        dataSource.messages = messages
        dataSource.selectedRow = { [weak self] indexPath in
            if let _ = self?.searchMessageIndex {
                self?.cancelSearchButtonTapped()
            }
            self?.viewWasTapped()
            self?.showAlert(forIndexPath: indexPath)
        }
        dataSource.showHideLabelCount = { [weak self] isShow in
            self?.noMassageLabel.isHidden = isShow
        }
        rowBuilder.didTapLocation = { [weak self] location in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.didTappedLocationCell(withLocation: location, viewController: strongSelf)
        }
    }
    
    func addSearchButton() {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search,
                                                        target: self,
                                                        action: #selector(ChatViewController.searchButtonTapped))
        
        self.navigationItem.rightBarButtonItem = searchButton
    }
    
    func addCancelSearchButton() {
        let cancelSearchButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                              target: self,
                                                              action: #selector(ChatViewController.cancelSearchButtonTapped))
        
        self.navigationItem.rightBarButtonItem = cancelSearchButton
    }
    
    @objc func cancelSearchButtonTapped() {
        addSearchButton()
        searchView?.removeFromSuperview()
        searchView = nil
        hideKeyboard()
        searchMessageChangeColor()
    }
    
    func searchMessageChangeColor() {
        if let searchMessageIndex = searchMessageIndex {
            tableView.cellForRow(at: IndexPath(row: searchMessageIndex, section: 0))?.backgroundColor = UIColor.clear
            self.searchMessageIndex = nil
        }
    }
    
    @objc func searchButtonTapped() {
        view.endEditing(true)
        addCancelSearchButton()
        hideKeyboard()
        let searchView = UINib(nibName: "SearchView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SearchView
        searchView.configure(model: SearchViewViewModel(placeholder: searchTextPlaceholder,
                                                        calendarIcon: calendarIcon,
                                                        searchToTopIcon: searchToTopIcon,
                                                        searchToBottomIcon: searchToBottomIcon,
                                                        endInput: { [weak self] text in
                                                                      self?.searchMessageChangeColor()
                                                                      let searchText = text.lowercased()
                                                                      let textMessages = self?.messages.filter {
                                                                          switch $0.kind {
                                                                          case .text(let text):
                                                                              if text.lowercased().contains(searchText) {
                                                                                  return true
                                                                              }
                                                                          default:
                                                                              return false
                                                                          }
                                                                          return false
                                                                      }
                                                                      if let textMessages = textMessages {
                                                                          return textMessages.reversed()
                                                                      }
                                                                      return [Message]()
                                                                  },
                                                     showMessage: { message in
                                                                      guard let index = self.messages.firstIndex(of: message) else { return }
                                                                      self.searchMessageIndex = index
                                                                      self.dataSource.scrollToRow(at: IndexPath(row: index, section: 0),
                                                                                                  at: .middle,
                                                                                            animated: true)
                                                                      self.dataSource.changeBackground(forIndexPath: IndexPath(row: index, section: 0), isSearch: true)
                                                                  },
                                               willChangeMessage: { message in
                                                                      guard let index = self.messages.firstIndex(of: message) else { return }
                                                                      self.searchMessageIndex = index
                                                                      self.dataSource.changeBackground(forIndexPath: IndexPath(row: index, section: 0), isSearch: false)
                                                                  },
                                                    showCalendar: {
                                                                      self.hideKeyboard()
                                                                      self.searchMessageChangeColor()
                                                                      self.delegate?.didTappedCalendarButton(viewController: self)
                                                                  }))
        self.view.addSubview(searchView)
        self.searchView = searchView
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        searchView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        searchView.leftAnchor.constraint(equalTo: bottomView.leftAnchor).isActive = true
        searchView.rightAnchor.constraint(equalTo: bottomView.rightAnchor).isActive = true
    }
    
    func insertNewMessage(_ message: Message) {
        if isAnswer {
            if let answerMessageId = answerView.message?.messageId {
                message.answer = answerMessageId
            }
            isAnswer = false
        }
        
        messages.append(message)
        delegate?.didTouchSendMessageButton(with: message,
                                          toUser: toUser,
                                  viewController: self)
        messages.sort { $0.sentDate.toString(dateFormat: "yyyy-MM-dd hh:mm:ss") < $1.sentDate.toString(dateFormat: "yyyy-MM-dd hh:mm:ss")  }
        
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

    @objc func viewWasTapped() {
        self.view.endEditing(true)
        if isGiphyInput {
            isGiphyInput.toggle()
            textView.text = "Input text..."
            giphyButton.setImage(defaultStateGiphyImage, for: .normal)
        }
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
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print(view.safeAreaInsets.bottom)
            giphyViewHeight.constant = keyboardSize.height + view.safeAreaInsets.bottom
            giphyViewController.changeCollectionViewHeight(height: giphyViewHeight.constant)
            bottomGiphyViewConstraint.constant = -giphyViewHeight.constant*2
            textViewBottomConstraint.constant = -(keyboardSize.height - self.view.safeAreaInsets.bottom)
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.tableView.scrollToBottom(animated: true)
            }
        }
    }
}

extension ChatViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if isGiphyInput {
            textView.text = searchGiphyPlaceholder
        } else {
            textView.text = inputTextPlaceholder
        }
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
        searchGiphyButtonLeftConstraint.constant = 48
        UIView.animate(withDuration: 0.4) {
            self.cameraButton.alpha = 1
            self.getFileButton.alpha = 1
            self.sendMessageButton.alpha = 0
            self.searchGiphyButton.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func newTextInTextView() {
        sendMessageButtonLeftConstraint.constant = 12
        searchGiphyButtonLeftConstraint.constant = 12
        UIView.animate(withDuration: 0.4) {
            self.cameraButton.alpha = 0
            self.getFileButton.alpha = 0
            if self.isGiphyInput {
                self.searchGiphyButton.alpha = 1
            } else {
                self.sendMessageButton.alpha = 1
            }
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
                                  answer: nil,
                               messageId: UUID().uuidString,
                                sentDate: Date(),
                                    kind: MessageKind.photo(MediaItem(image: image,
                                                                       size: size,
                                                                 downloaded: false)))
            insertNewMessage(message)
        } else if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
            let message = Message(sender: currentUser!,
                                  answer: nil,
                               messageId: UUID().uuidString,
                                sentDate: Date(),
                                    kind: MessageKind.video(VideoItem(videoUrl: videoUrl, downloaded: false)))
            insertNewMessage(message)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ChatViewController {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hideKeyboard()
    }
    
    private func showAlert(forIndexPath indexPath: IndexPath) {
        guard messages[indexPath.row].sender == currentUser else {
            answer(forMessage: messages[indexPath.row])
            return
        }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        switch messages[indexPath.row].kind {
        case .text(let text):
            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
                self.textView.becomeFirstResponder()
                self.textView.text = text
                self.newTextInTextView()
                self.editingMessage = self.messages[indexPath.row]
            }))
        default:
            break
        }
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.delegate?.didTappedRemoveMessageButton(message: self.messages[indexPath.row],
                                                         toUser: self.toUser,
                                                 viewController: self)
            self.messages.remove(at: indexPath.row)
            self.tableView.reloadData()
            self.tableView.scrollToBottom(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func answer(forMessage message: Message) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Answer",
                                      style: .default,
                                    handler: { [weak self] _ in
                                                  guard let strongSelf = self else { return }
                                                  strongSelf.isAnswer = true
                                                  strongSelf.answerView.configure(model: AnswerViewViewModel(answerMessage: message,
                                                                                                                 closeView: { [weak self] in
                                                                                                                                self?.isAnswer = false
                                                                                                                            }))
                                             }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ChatViewController: ChatViewControllerProtocol {
   
    func changeAnswerMessage(messageFont: UIFont, messageColor: UIColor, nameFont: UIFont, nameColor: UIColor, boardColor: UIColor, boardWidth: CGFloat) {
        rowBuilder.setDefaultAnswerMessage(messageFont: messageFont,
                                          messageColor: messageColor,
                                              nameFont: nameFont,
                                             nameColor: nameColor,
                                            boardColor: boardColor,
                                            boardWidth: boardWidth)
    }
    
    func changeBubble(inputBubble input: UIImage, outputBubble output: UIImage) {
        rowBuilder.setDefaultBubbles(inputBubble: input, outputBubble: output)
    }
    
    func change(font: UIFont) {
        rowBuilder.setMessageFont(font: font)
    }
    
    func changeColorMessage(inputColor: UIColor, outputColor: UIColor) {
        rowBuilder.setMessageColor(input: inputColor, output: outputColor)
    }
    
    func changeLocation(withImage image: UIImage, size: CGSize) {
        rowBuilder.setDefaultLocation(image: image, size: size)
    }
    
    func changeIcons(sendMessage: UIImage, camera: UIImage, files: UIImage) {
        sendMessageButton.setImage(sendMessage, for: .normal)
        cameraButton.setImage(camera, for: .normal)
        getFileButton.setImage(files, for: .normal)
    }
    
    func changeGiphyIcons(activeState: UIImage, defaultState: UIImage) {
        activeStateGiphyImage = activeState
        defaultStateGiphyImage = defaultState
        giphyButton.setImage(isGiphyInput ? activeState : defaultState, for: .normal)
    }
    
    func changeIcons(calendar: UIImage, searchToTop: UIImage, searchToBottom: UIImage) {
        calendarIcon = calendar
        searchToBottomIcon = searchToBottom
        searchToTopIcon = searchToTop
    }
    
    func changePlaceHolder(forInputText text: String) {
        inputTextPlaceholder = text
    }
    
    func changePlaceHolder(forSearchGiphy text: String) {
        searchGiphyPlaceholder = text
    }
    
    func changePlaceHolder(forSearchMessage text: String) {
        searchTextPlaceholder = text
    }
    
    func changeOffsetForUserIcon(toMessage: CGFloat, toBoard: CGFloat) {
        rowBuilder.setDefaultOffsetForUserImage(toMessage: toMessage, toBoard: toBoard)
    }
    
    func changeTimeLabelColor(forMessage messageColor: UIColor, forMedia mediaColor: UIColor, font: UIFont) {
        rowBuilder.setDefault(timeLabelFont: font,
                   timeLabelColorForMessage: messageColor,
                     timeLabelColorForMedia: mediaColor)
    }
}

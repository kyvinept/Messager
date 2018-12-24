//
//  AttachmentsViewController.swift
//  Messager
//
//  Created by Silchenko on 24.12.2018.
//

import UIKit

class AttachmentsViewController: UIViewController {
    
    var backButtonTapped: (() -> ())?
    
    enum AttachmentsType: Int {
        case all
        case image
        case video
        case location
        case giphy
    }
    
    @IBOutlet private weak var noAttachment: UILabel!
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    private var allMessages = [Message]() {
        didSet {
            allMessages.removeAll(where: {
                switch $0.kind {
                case .text(_):
                    return true
                default:
                    return false
                }
            })
        }
    }
    private var messages = [Message]()
    private var currentAttachmentsType: AttachmentsType = .all {
        didSet {
            messages = allMessages
            guard currentAttachmentsType != .all else {
                tableView.reloadData()
                return
            }
            messages.removeAll(where: {
                switch $0.kind {
                case .photo(_):
                    return currentAttachmentsType != .image
                case .location(_):
                    return currentAttachmentsType != .location
                case .video(_):
                    return currentAttachmentsType != .video
                case .giphy(_):
                    return currentAttachmentsType != .giphy
                default:
                    return false
                }
            })
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        tableView.reloadData()
        createBackButton()
    }

    func configure(messages: [Message]) {
        allMessages = messages
        allMessages.sort(by: { $0.sentDate.toString() < $1.sentDate.toString() })
        self.messages = allMessages
    }
    
    @IBAction func attachmentsTypeValueChanged(_ sender: Any) {
        currentAttachmentsType = AttachmentsType(rawValue: segmentControl.selectedSegmentIndex) ?? .all
    }
}

extension AttachmentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noAttachment.isHidden = messages.count > 0
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AttachmentCell
        cell.configure(model: AttachmentCellViewModel(messageKind: messages[indexPath.row].kind))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

private extension AttachmentsViewController {
    
    func createBackButton() {
        let back = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(AttachmentsViewController.backButtonWasTapped))
        self.navigationItem.leftBarButtonItem = back
    }
    
    @objc func backButtonWasTapped() {
        backButtonTapped?()
    }
    
    func registerCell() {
        tableView.register(UINib(nibName: "AttachmentCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
}

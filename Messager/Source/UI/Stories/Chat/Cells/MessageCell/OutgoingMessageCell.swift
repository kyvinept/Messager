//
//  MessageCell.swift
//  Messager
//
//  Created by Silchenko on 30.10.2018.
//

import UIKit

class OutgoingMessageCell: UITableViewCell {
    
    @IBOutlet private weak var messageLabel: UILabel!

    func configure(model: MessageCellViewModel) {
        messageLabel.text = model.message
    }
}

//
//  MessageCell.swift
//  Messager
//
//  Created by Silchenko on 30.10.2018.
//

import UIKit

class OutgoingMessageCell: UITableViewCell {
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var userImageView: UIImageView!
    private let rightShift: CGFloat = 50;
    
    func configure(model: MessageCellViewModel) {
        messageLabel.text = model.message
        timeLabel.text = model.date
        
        let maxMessageWidth = UIScreen.main.bounds.width - userImageView.frame.width - rightShift
        print(messageLabel)
        print(messageLabel.frame.width)
        if messageLabel.frame.width > maxMessageWidth {
            let widthConstraint = NSLayoutConstraint(item: messageLabel,
                                                attribute:  .width,
                                                relatedBy: .equal,
                                                   toItem: nil,
                                                attribute: .notAnAttribute,
                                               multiplier: 1,
                                                 constant: maxMessageWidth)
            self.addConstraint(widthConstraint)
        }
    }
}

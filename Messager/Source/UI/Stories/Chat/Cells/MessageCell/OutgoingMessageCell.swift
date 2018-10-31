//
//  MessageCell.swift
//  Messager
//
//  Created by Silchenko on 30.10.2018.
//

import UIKit

class OutgoingMessageCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(model: MessageCellViewModel) {
        messageLabel.text = model.message
    }
}

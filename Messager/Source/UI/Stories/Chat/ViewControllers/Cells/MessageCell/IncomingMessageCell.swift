//
//  MessageCell.swift
//  Messager
//
//  Created by Silchenko on 30.10.2018.
//

import UIKit

class IncomingMessageCell: CustomCell {
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var userImage: UIImageView!
    
    override func configure(model: CustomViewModel) {
        super.configure(model: model)
        guard let model = model as? MessageCellViewModel else { return }
        
        messageLabel.text = model.message
        timeLabel.text = model.date
        userImage.downloadImage(from: model.userImageUrl)
        
        self.backgroundColor = model.backgroundColor
    }
}

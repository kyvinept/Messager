//
//  MessageCell.swift
//  Messager
//
//  Created by Silchenko on 30.10.2018.
//

import UIKit

class IncomingMessageCell: CustomCell {
    
    @IBOutlet private weak var bubble: UIImageView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var answerView: AnswerViewForCell!
    @IBOutlet private weak var answerViewTopConstraint: NSLayoutConstraint!
    
    override func configure(model: CustomViewModel, answerModel: AnswerViewForCellViewModel?) {
        super.configure(model: model, answerModel: answerModel)
        guard let model = model as? MessageCellViewModel else { return }
        
        messageLabel.text = model.message
        timeLabel.text = model.date
        userImage.downloadImage(from: model.userImageUrl)
        
        bubble.image = model.inputBubble
        self.backgroundColor = model.backgroundColor
        
        answerViewTopConstraint.constant = -answerView.frame.height
        answerView.isHidden = true
        guard let answerModel = answerModel else { return }
        answerView.configure(model: answerModel)
        answerViewTopConstraint.constant = 4
        answerView.isHidden = false
    }
}

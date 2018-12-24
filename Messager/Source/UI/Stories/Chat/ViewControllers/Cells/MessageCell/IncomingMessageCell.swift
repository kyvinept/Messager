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
    @IBOutlet private weak var userImageViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var userImageViewRightConstraint: NSLayoutConstraint!
    
    override func configure(model: CustomViewModel, defaultModel: DefaultViewModel, answerModel: AnswerViewForCellViewModel?) {
        super.configure(model: model, defaultModel: defaultModel, answerModel: answerModel)
        guard let model = model as? MessageCellViewModel else { return }
        
        setModelParameters(model: model)
        setDefaultParameters(model: defaultModel)
        
        guard let answerModel = answerModel else { return }
        answerView.configure(model: answerModel, withFont: defaultModel.timeLabelFont)
        answerViewTopConstraint.constant = 4
        answerView.isHidden = false
    }
    
    private func setModelParameters(model: MessageCellViewModel) {
        messageLabel.text = model.message
        messageLabel.textColor = model.inputColor
        messageLabel.font = model.font
        timeLabel.text = model.date
        userImage.downloadImage(from: model.userImageUrl)
        
        bubble.image = model.inputBubble
        self.backgroundColor = model.backgroundColor
        
        answerViewTopConstraint.constant = -answerView.frame.height
        answerView.isHidden = true
    }
    
    private func setDefaultParameters(model: DefaultViewModel) {
        userImageViewLeftConstraint.constant = model.toMessage
        userImageViewRightConstraint.constant = model.toBoard
        timeLabel.textColor = model.timeLabelColorForMessage
        timeLabel.font = model.timeLabelFont
    }
}

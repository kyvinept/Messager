//
//  IncomingImageCell.swift
//  Messager
//
//  Created by Silchenko on 30.10.2018.
//

import UIKit

class IncomingImageCell: CustomCell {

    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var messageImage: UIImageView!
    @IBOutlet private weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var userImageViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var userImageViewRightConstraint: NSLayoutConstraint!
    
    override func configure(model: CustomViewModel, defaultModel: DefaultViewModel, answerModel: AnswerViewForCellViewModel?) {
        super.configure(model: model, defaultModel: defaultModel, answerModel: answerModel)
        guard let model = model as? ImageCellViewModel else { return }
        
        setDefaultParameters(model: defaultModel)
        
        messageImage.image = model.image
        timeLabel.text = model.date
        userImage.downloadImage(from: model.userImageUrl)
        
        imageViewWidthConstraint.constant = model.imageSize.width
        imageViewHeightConstraint.constant = model.imageSize.height
    }
    
    private func setDefaultParameters(model: DefaultViewModel) {
        userImageViewLeftConstraint.constant = model.toBoard
        userImageViewRightConstraint.constant = model.toMessage
        timeLabel.textColor = model.timeLabelColorForMedia
        timeLabel.font = model.timeLabelFont
    }
}

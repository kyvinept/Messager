//
//  OutgoingImageCell.swift
//  Messager
//
//  Created by Silchenko on 30.10.2018.
//

import UIKit

class OutgoingImageCell: CustomCell {

    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var messageImage: UIImageView!
    @IBOutlet private weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var userImageViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var userImageViewRightConstraint: NSLayoutConstraint!
    
    override func configure(model: CustomViewModel, defaultModel: DefaultViewModel, answerModel: AnswerViewForCellViewModel?) {
        super.configure(model: model, defaultModel: defaultModel, answerModel: answerModel)
        guard let model = model as? ImageCellViewModel else { return }
        
        messageImage.image = model.image
        userImage.downloadImage(from: model.userImageUrl)
        timeLabel.text = model.date

        imageViewWidthConstraint.constant = model.imageSize.width
        imageViewHeightConstraint.constant = model.imageSize.height
    
        setDefaultParameters(model: defaultModel)
        
        if !model.downloaded {
            activityIndicator.startAnimating()
            loadingView.isHidden = false
        } else {
            loadingView.isHidden = true
        }
    }
    
    private func setDefaultParameters(model: DefaultViewModel) {
        userImageViewLeftConstraint.constant = model.toMessage
        userImageViewRightConstraint.constant = model.toBoard
        timeLabel.textColor = model.timeLabelColorForMedia
        timeLabel.font = model.timeLabelFont
    }
    
    func imageIsDownloaded() {
        activityIndicator.stopAnimating()
        loadingView.isHidden = true
    }
}

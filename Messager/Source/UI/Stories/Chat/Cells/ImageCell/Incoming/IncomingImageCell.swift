//
//  IncomingImageCell.swift
//  Messager
//
//  Created by Silchenko on 30.10.2018.
//

import UIKit

class IncomingImageCell: UITableViewCell {

    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var messageImage: UIImageView!
    @IBOutlet private weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var timeLabel: UILabel!
    
    func configure(model: ImageCellViewModel) {
        messageImage.image = model.image
        timeLabel.text = model.date
        userImage.downloadImage(from: model.userImageUrl)
        
        imageViewWidthConstraint.constant = model.imageSize.width
        imageViewHeightConstraint.constant = model.imageSize.height
    }
}

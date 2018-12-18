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
    
    override func configure(model: CustomViewModel) {
        super.configure(model: model)
        guard let model = model as? ImageCellViewModel else { return }
        
        messageImage.image = model.image
        timeLabel.text = model.date
        userImage.downloadImage(from: model.userImageUrl)
        
        imageViewWidthConstraint.constant = model.imageSize.width
        imageViewHeightConstraint.constant = model.imageSize.height
    }
}

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
    private let horizontalMargin: CGFloat = 0
    private let verticalMargin: CGFloat = 13
    @IBOutlet private weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var timeLabelLeftConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(model: ImageCellViewModel) {
        messageImage.image = model.image
        
        imageViewWidthConstraint.constant = model.imageSize.width
        imageViewHeightConstraint.constant = model.imageSize.height
        
        timeLabelLeftConstraint.constant = model.imageSize.width + userImage.frame.width - timeLabel.frame.width
    }
}

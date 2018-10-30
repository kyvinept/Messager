//
//  OutgoingImageCell.swift
//  Messager
//
//  Created by Silchenko on 30.10.2018.
//

import UIKit

class OutgoingImageCell: UITableViewCell {

    @IBOutlet private weak var messageImage: UIImageView!
    private let horizontalMargin: CGFloat = 0
    private let verticalMargin: CGFloat = 13
    @IBOutlet private weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bubbleWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bubbleHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var timeLabelWidthConstraint: NSLayoutConstraint!
    private let shiftTime: CGFloat = -23
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(model: ImageCellViewModel) {
        messageImage.image = model.image
        
        imageViewWidthConstraint.constant = model.imageSize.width
        imageViewHeightConstraint.constant = model.imageSize.height
        
        bubbleWidthConstraint.constant = model.imageSize.width + horizontalMargin
        bubbleHeightConstraint.constant = model.imageSize.height + verticalMargin
        
        timeLabelWidthConstraint.constant = model.imageSize.width + shiftTime
    }
}

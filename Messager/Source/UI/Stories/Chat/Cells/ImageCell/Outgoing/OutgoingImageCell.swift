//
//  OutgoingImageCell.swift
//  Messager
//
//  Created by Silchenko on 30.10.2018.
//

import UIKit

class OutgoingImageCell: UITableViewCell {

    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var messageImage: UIImageView!
    @IBOutlet private weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    func configure(model: ImageCellViewModel) {
        messageImage.image = model.image
        
        timeLabel.text = model.date

        imageViewWidthConstraint.constant = model.imageSize.width
        imageViewHeightConstraint.constant = model.imageSize.height
    
        if !model.downloaded {
            activityIndicator.startAnimating()
            loadingView.isHidden = false
        } else {
            loadingView.isHidden = true
        }
    }
    
    func imageIsDownloaded() {
        activityIndicator.stopAnimating()
        loadingView.isHidden = true
    }
}

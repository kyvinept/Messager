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
    
    override func configure(model: CustomViewModel) {
        super.configure(model: model)
        guard let model = model as? ImageCellViewModel else { return }
        
        messageImage.image = model.image
        userImage.downloadImage(from: model.userImageUrl)
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

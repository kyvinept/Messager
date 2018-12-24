//
//  AttachmentCell.swift
//  Messager
//
//  Created by Silchenko on 24.12.2018.
//

import UIKit

class AttachmentCell: UITableViewCell {

    @IBOutlet private weak var attachmentImageView: UIImageView!
    @IBOutlet private weak var widthImageViewContraint: NSLayoutConstraint!
    @IBOutlet private weak var heightImageViewConstraint: NSLayoutConstraint!
    private var progress: UIActivityIndicatorView!
    private var widthLocationImage: CGFloat = 120
    private var heightLocationImage: CGFloat = 57
    
    override func prepareForReuse() {
        attachmentImageView.image = nil
    }
    
    func configure(model: AttachmentCellViewModel) {
        switch model.messageKind {
        case .photo(let mediaItem):
            widthImageViewContraint.constant = mediaItem.size.width
            heightImageViewConstraint.constant = mediaItem.size.height
            attachmentImageView.image = mediaItem.image
        case .location(_):
            attachmentImageView.image = UIImage(named: "location")
            widthImageViewContraint.constant = widthLocationImage
            heightImageViewConstraint.constant = heightLocationImage
        case .giphy(let giphy):
            downloadGiphy(url: giphy.url)
            widthImageViewContraint.constant = giphy.width
            heightImageViewConstraint.constant = giphy.height
        default:
            break
        }
    }
    
    private func downloadGiphy(url: String) {
        progress = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.addSubview(progress)
        progress.center = attachmentImageView.center
        progress.startAnimating()
        DispatchQueue(label: "com.giphy.tableViewCell", attributes: .concurrent).async {
            guard let bundleURL = URL(string: url) else {
                return
            }
            guard let imageData = try? Data(contentsOf: bundleURL) else {
                return
            }
            let image = UIImage.sd_animatedGIF(with: imageData)
            
            DispatchQueue.main.async {
                self.progress.removeFromSuperview()
                self.attachmentImageView.image = image
            }
        }
    }
}

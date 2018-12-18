//
//  OutgoingGiphyCell.swift
//  Messager
//
//  Created by Silchenko on 21.11.2018.
//

import UIKit

class OutgoingGiphyCell: UITableViewCell {

    @IBOutlet private weak var giphyView: UIImageView!
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    private var progress: UIActivityIndicatorView!
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewWidthConstraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        giphyView.image = nil
    }

    func configure(model: GiphyChatCellViewModel) {
        userImage.downloadImage(from: model.userImageUrl)
        downloadGiphy(url: model.url)
        dateLabel.text = model.date
    }
    
    private func downloadGiphy(url: String) {
        progress = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.addSubview(progress)
        progress.center = giphyView.center
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
                self.giphyView.image = image
                if let size = image?.getSizeForMessage() {
                    self.imageViewWidthConstraint.constant = size.width * 0.6
                    self.imageViewHeightConstraint.constant = size.height * 0.6
                }
            }
        }
    }
}

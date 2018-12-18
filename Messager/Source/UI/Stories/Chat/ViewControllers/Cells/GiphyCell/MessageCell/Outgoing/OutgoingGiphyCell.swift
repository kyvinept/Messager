//
//  OutgoingGiphyCell.swift
//  Messager
//
//  Created by Silchenko on 21.11.2018.
//

import UIKit

class OutgoingGiphyCell: CustomCell {

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

    override func configure(model: CustomViewModel) {
        guard let model = model as? GiphyChatCellViewModel else { return }
        
        userImage.downloadImage(from: model.userImageUrl)
        downloadGiphy(url: model.giphy.url)
        dateLabel.text = model.date
        self.imageViewWidthConstraint.constant = model.giphy.width
        self.imageViewHeightConstraint.constant = model.giphy.height
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
            }
        }
    }
}

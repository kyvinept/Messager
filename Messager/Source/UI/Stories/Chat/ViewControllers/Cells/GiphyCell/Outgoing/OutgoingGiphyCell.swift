//
//  OutgoingGiphyCell.swift
//  Messager
//
//  Created by Silchenko on 16.11.2018.
//

import UIKit
import AVFoundation
import SDWebImage
import JGProgressHUD

class OutgoingGiphyCell: UICollectionViewCell {

    @IBOutlet weak var giphyView: UIImageView!
    
    func configure(model: GiphyCellViewModel) {
        downloadGiphy(id: model.id)
    }
    
    private func downloadGiphy(id: String) {
        let progress = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.addSubview(progress)
        progress.center = self.center
        progress.startAnimating()
        DispatchQueue(label: "com.giphy", attributes: .concurrent).async {
            guard let bundleURL = URL(string: "https://media.giphy.com/media/\(id)/giphy.gif") else {
                return
            }
            guard let imageData = try? Data(contentsOf: bundleURL) else {
                return
            }
            let image = UIImage.sd_animatedGIF(with: imageData)
            DispatchQueue.main.async {
                progress.removeFromSuperview()
                self.giphyView.image = image
            }
        }
    }
}

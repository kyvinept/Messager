//
//  OutgoingGiphyCell.swift
//  Messager
//
//  Created by Silchenko on 16.11.2018.
//

import UIKit
import AVFoundation
import SDWebImage

class OutgoingGiphyCell: UICollectionViewCell {

    @IBOutlet weak var giphyView: UIImageView!
    
    func configure(model: GiphyCellViewModel) {
        downloadGiphy(id: model.id)
    }
    
    private func downloadGiphy(id: String) {
        guard let bundleURL = URL(string: "https://media.giphy.com/media/\(id)/giphy.gif") else {
            return
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            return
        }
        
        let image = UIImage.sd_animatedGIF(with: imageData)
        giphyView.image = image
    }
}

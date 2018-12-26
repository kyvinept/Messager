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

class GiphyCell: UICollectionViewCell {

    @IBOutlet private weak var giphyView: UIImageView!
    private var progress: UIActivityIndicatorView!
    private var choseGiphy: ((Giphy) -> ())?
    private var previewGiphy: ((String) -> ())?
    private var endPreviewGiphy: (() -> ())?
    private var giphy: Giphy!
    
    func configure(model: GiphyCellViewModel) {
        addGesture()
        self.choseGiphy = model.choseGiphy
        self.giphy = model.giphy
        self.previewGiphy = model.previewGiphy
        self.endPreviewGiphy = model.endPreviewGiphy
        downloadGiphy(id: model.giphy.id)
    }
    
    private func downloadGiphy(id: String) {
        progress = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.addSubview(progress)
        progress.center = giphyView.center
        progress.startAnimating()
        DispatchQueue(label: "com.giphy", attributes: .concurrent).async {
            guard let bundleURL = URL(string: "https://media.giphy.com/media/\(id)/200w_d.gif") else {
                return
            }
            self.giphy.url = bundleURL.absoluteString
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
    
    private func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(GiphyCell.viewWasTapped))
        let press = UILongPressGestureRecognizer(target: self, action: #selector(GiphyCell.viewWasPressed))
        press.minimumPressDuration = 0.5
        self.addGestureRecognizer(tap)
        self.addGestureRecognizer(press)
    }
    
    @objc private func viewWasTapped() {
        choseGiphy?(giphy)
    }
    
    @objc private func viewWasPressed(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            previewGiphy?(giphy.url)
        }
        
        if gesture.state == .ended {
            endPreviewGiphy?()
        }
    }
}

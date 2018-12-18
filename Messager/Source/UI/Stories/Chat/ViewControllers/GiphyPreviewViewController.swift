//
//  GiphyPreviewViewController.swift
//  Messager
//
//  Created by Silchenko on 14.12.2018.
//

import UIKit

class GiphyPreviewViewController: UIViewController {

    private var progress: UIActivityIndicatorView!
    private var url = ""
    @IBOutlet private weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadGiphy(url: url)
    }
    
    func configure(url: String) {
        self.url = url
        if imageView != nil {
            downloadGiphy(url: url)
        }
    }
}

private extension GiphyPreviewViewController {
    
    func downloadGiphy(url: String) {
        progress = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.view.addSubview(progress)
        progress.center = imageView.center
        progress.startAnimating()
        DispatchQueue(label: "com.giphyPreview", attributes: .concurrent).async {
            guard let bundleURL = URL(string: url) else {
                return
            }
            guard let imageData = try? Data(contentsOf: bundleURL) else {
                return
            }
            let image = UIImage.sd_animatedGIF(with: imageData)
            DispatchQueue.main.async {
                self.progress.stopAnimating()
                self.imageView.image = image
            }
        }
    }
}

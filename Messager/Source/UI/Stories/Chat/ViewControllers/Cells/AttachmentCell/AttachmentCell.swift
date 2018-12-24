//
//  AttachmentCell.swift
//  Messager
//
//  Created by Silchenko on 24.12.2018.
//

import UIKit
import AVFoundation

class AttachmentCell: UITableViewCell {

    @IBOutlet private weak var attachmentImageView: UIImageView!
    @IBOutlet private weak var widthImageViewContraint: NSLayoutConstraint!
    @IBOutlet private weak var heightImageViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var playButton: UIImageView!
    private var progress: UIActivityIndicatorView!
    private var widthLocationImage: CGFloat = 120
    private var heightLocationImage: CGFloat = 57
    private var player: AVPlayer?
    private var isPlay = false {
        didSet {
            playButton.isHidden = isPlay
        }
    }
    
    override func prepareForReuse() {
        attachmentImageView.image = nil
        attachmentImageView.layer.sublayers?.removeAll()
        playButton.isHidden = true
        attachmentImageView.gestureRecognizers?.removeAll()
    }
    
    func configure(model: AttachmentCellViewModel) {
        playButton.isHidden = true
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
        case .video(let videoItem):
            playButton.isHidden = false
            setVideo(videoItem)
        default:
            break
        }
    }
    
    private func setVideo(_ videoItem: VideoItem) {
        let size = videoItem.videoUrl.sizeForMessage!
        widthImageViewContraint.constant = size.width
        heightImageViewConstraint.constant = size.height
        
        player = AVPlayer(url: videoItem.videoUrl)
        let videoLayer = AVPlayerLayer(player: player)
        videoLayer.frame.size = size
        attachmentImageView.layer.addSublayer(videoLayer)
        
        setGesture()
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
    
    private func setGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(AttachmentCell.videoWasTapped))
        attachmentImageView.addGestureRecognizer(tap)
    }
    
    @objc func videoWasTapped() {
        if isPlay {
            player?.pause()
        } else {
            player?.play()
        }
        isPlay.toggle()
    }
}

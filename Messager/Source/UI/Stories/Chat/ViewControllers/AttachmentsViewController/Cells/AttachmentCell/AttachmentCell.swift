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
    private var model: AttachmentCellViewModel!
    private var isPlay = false {
        didSet {
            playButton.alpha = isPlay ? 0.25 : 1
            playButton.image = isPlay ? UIImage(named: "pause") : UIImage(named: "play")
        }
    }
    
    override func prepareForReuse() {
        attachmentImageView.image = nil
        attachmentImageView.layer.sublayers?.removeAll()
        playButton.isHidden = true
        attachmentImageView.gestureRecognizers?.removeAll()
        model = nil
    }
    
    func configure(model: AttachmentCellViewModel) {
        self.model = model
        playButton.isHidden = true
        switch model.messageKind {
        case .photo(let mediaItem):
            widthImageViewContraint.constant = mediaItem.size.width
            heightImageViewConstraint.constant = mediaItem.size.height
            attachmentImageView.image = mediaItem.image
            setGesture(withSelector: #selector(AttachmentCell.imageWasTapped), toView: attachmentImageView)
        case .location(_):
            attachmentImageView.image = UIImage(named: "location")
            widthImageViewContraint.constant = widthLocationImage
            heightImageViewConstraint.constant = heightLocationImage
            setGesture(withSelector: #selector(AttachmentCell.locationWasTapped), toView: attachmentImageView)
        case .giphy(let giphy):
            downloadGiphy(url: giphy.url)
            widthImageViewContraint.constant = giphy.width
            heightImageViewConstraint.constant = giphy.height
        case .video(let videoItem):
            playButton.isHidden = false
            setVideo(videoItem)
            setGesture(withSelector: #selector(AttachmentCell.videoWasTapped), toView: playButton)
            setGesture(withSelector: #selector(AttachmentCell.fullViewWasTapped), toView: attachmentImageView)
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
    
    @objc private func fullViewWasTapped() {
        switch model.messageKind {
        case .video(let videoItem):
            model.showFullVideo?(videoItem)
        default:
            break
        }
    }
    
    private func setGesture(withSelector selector: Selector, toView: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: selector)
        toView.addGestureRecognizer(tap)
    }
    
    @objc private func videoWasTapped() {
        if isPlay {
            player?.pause()
        } else {
            player?.play()
        }
        isPlay.toggle()
    }
    
    @objc private func imageWasTapped() {
        if let image = attachmentImageView.image {
            model.showFullImage?(image)
        }
    }
    
    @objc private func locationWasTapped() {
        switch model.messageKind {
        case .location(let coordinate):
            model.showLocation?(coordinate)
        default:
            break
        }
    }
}

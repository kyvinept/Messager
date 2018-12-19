//
//  IncomingVideoCell.swift
//  Messager
//
//  Created by Silchenko on 15.11.2018.
//

import UIKit
import AVFoundation

class IncomingVideoCell: CustomCell {

    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var videoView: UIView!
    @IBOutlet private weak var playButton: UIImageView!
    @IBOutlet private weak var widthVideoViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var heightVideoViewConstraint: NSLayoutConstraint!
    private var isPlay: Bool = false {
        didSet {
            playButton.isHidden = isPlay
        }
    }
    private var player: AVPlayer!
    
    override func configure(model: CustomViewModel, answerModel: AnswerViewForCellViewModel?) {
        super.configure(model: model, answerModel: answerModel)
        guard let model = model as? VideoCellViewModel else { return }
        
        userImage.downloadImage(from: model.userImageUrl)
        playButton.layer.zPosition = 100000
        
        let size = model.video.sizeForMessage!
        widthVideoViewConstraint.constant = size.width
        heightVideoViewConstraint.constant = size.height
        
        player = AVPlayer(url: model.video)
        let videoLayer = AVPlayerLayer(player: player)
        videoLayer.frame.size = size
        videoView.layer.addSublayer(videoLayer)
        
        setTapGesture()
    }
    
    private func setTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(IncomingVideoCell.videoViewTapped))
        videoView.addGestureRecognizer(tap)
    }
    
    @objc private func videoViewTapped(_ gesture: UITapGestureRecognizer) {
        if isPlay {
            player.pause()
        } else {
            player.play()
        }
        isPlay.toggle()
    }
}

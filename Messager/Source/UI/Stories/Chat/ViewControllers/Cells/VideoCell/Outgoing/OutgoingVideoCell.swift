//
//  OutgoingVideoCell.swift
//  Messager
//
//  Created by Silchenko on 15.11.2018.
//

import UIKit
import AVFoundation

class OutgoingVideoCell: CustomCell {

    @IBOutlet private weak var userImageViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var userImageViewRightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var playButton: UIImageView!
    @IBOutlet private weak var videoView: UIView!
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var widthVideoViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var heightVideoViewConstraint: NSLayoutConstraint!
    private var isPlay: Bool = false {
        didSet {
            playButton.isHidden = isPlay
        }
    }
    private var player: AVPlayer!
    
    override func configure(model: CustomViewModel, defaultModel: DefaultViewModel, answerModel: AnswerViewForCellViewModel?) {
        super.configure(model: model, defaultModel: defaultModel, answerModel: answerModel)
        guard let model = model as? VideoCellViewModel else { return }
        
        setDefaultParameters(model: defaultModel)
        
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
    
    private func setDefaultParameters(model: DefaultViewModel) {
        userImageViewLeftConstraint.constant = model.toMessage
        userImageViewRightConstraint.constant = model.toBoard
    }
    
    private func setTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(OutgoingVideoCell.videoViewTapped))
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

//
//  OutgoingGiphyCell.swift
//  Messager
//
//  Created by Silchenko on 21.11.2018.
//

import UIKit

class OutgoingGiphyCell: CustomCell {

    @IBOutlet private weak var userImageViewRightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var userImageViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var giphyView: UIImageView!
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    private var progress: UIActivityIndicatorView!
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var answerView: AnswerViewForCell!
    @IBOutlet private weak var containAnswerView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        giphyView.image = nil
    }

    override func configure(model: CustomViewModel, defaultModel: DefaultViewModel, answerModel: AnswerViewForCellViewModel?) {
        super.configure(model: model, defaultModel: defaultModel, answerModel: answerModel)
        guard let model = model as? GiphyChatCellViewModel else { return }
        
        setDefaultParameters(model: defaultModel)
        
        userImage.downloadImage(from: model.userImageUrl)
        downloadGiphy(url: model.giphy.url)
        dateLabel.text = model.date
        self.imageViewWidthConstraint.constant = model.giphy.width
        self.imageViewHeightConstraint.constant = model.giphy.height
        
        guard let answerModel = answerModel else {
            answerView.isHidden = true
            containAnswerView.isHidden = true
            return
        }
        answerView.isHidden = false
        containAnswerView.isHidden = false
        answerView.configure(model: answerModel)
    }
    
    private func setDefaultParameters(model: DefaultViewModel) {
        userImageViewRightConstraint.constant = model.toBoard
        userImageViewLeftConstraint.constant = model.toMessage
        dateLabel.textColor = model.timeLabelColorForMedia
        dateLabel.font = model.timeLabelFont
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

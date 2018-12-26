//
//  OutgoingLocationCell.swift
//  Messager
//
//  Created by Silchenko on 14.11.2018.
//

import UIKit

class OutgoingLocationCell: CustomCell {

    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var locationImageView: UIImageView!
    @IBOutlet private weak var userImageViewRightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var userImageViewLeftConstraint: NSLayoutConstraint!
    private var tapCell: ((CLLocationCoordinate2D) -> ())?
    private var location: CLLocationCoordinate2D!
    
    override func configure(model: CustomViewModel, defaultModel: DefaultViewModel, answerModel: AnswerViewForCellViewModel?) {
        super.configure(model: model, defaultModel: defaultModel, answerModel: answerModel)
        guard let model = model as? LocationCellViewModel else { return }
        
        setDefaultParameters(model: defaultModel)
        
        dateLabel.text = model.date
        userImage.downloadImage(from: model.userImageUrl)
        self.tapCell = model.tapCell
        self.location = model.location
        locationImageView.frame.size = model.locationImageSize
        locationImageView.image = model.locationImage
        
        addTapGesture()
    }
    
    private func setDefaultParameters(model: DefaultViewModel) {
        userImageViewLeftConstraint.constant = model.toMessage
        userImageViewRightConstraint.constant = model.toBoard
        dateLabel.textColor = model.timeLabelColorForMedia
        dateLabel.font = model.timeLabelFont
    }
    
    private func addTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(OutgoingLocationCell.didTappedCell))
        locationImageView.addGestureRecognizer(gesture)
    }
    
    @objc private func didTappedCell() {
        tapCell?(location)
    }
}

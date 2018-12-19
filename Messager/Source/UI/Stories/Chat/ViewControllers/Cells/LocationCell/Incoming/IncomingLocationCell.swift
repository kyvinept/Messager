//
//  IncomingLocationCell.swift
//  Messager
//
//  Created by Silchenko on 14.11.2018.
//

import UIKit

class IncomingLocationCell: CustomCell {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var locationImageView: UIImageView!
    private var tapCell: ((CLLocationCoordinate2D) -> ())?
    private var location: CLLocationCoordinate2D!
    
    override func configure(model: CustomViewModel, answerModel: AnswerViewForCellViewModel?) {
        super.configure(model: model, answerModel: answerModel)
        guard let model = model as? LocationCellViewModel else { return }
        
        dateLabel.text = model.date
        userImage.downloadImage(from: model.userImageUrl)
        self.tapCell = model.tapCell
        self.location = model.location
        
        addTapGesture()
    }
    
    private func addTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(IncomingLocationCell.didTappedCell))
        locationImageView.addGestureRecognizer(gesture)
    }
    
    @objc private func didTappedCell() {
        tapCell?(location)
    }
}

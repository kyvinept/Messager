//
//  IncomingLocationCell.swift
//  Messager
//
//  Created by Silchenko on 14.11.2018.
//

import UIKit

class IncomingLocationCell: UITableViewCell {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var userImage: UIImageView!
    private var tapCell: ((CLLocationCoordinate2D) -> ())?
    private var location: CLLocationCoordinate2D!
    
    func configure(model: LocationCellViewModel) {
        dateLabel.text = model.date
        userImage.downloadImage(from: model.userImageUrl)
        self.tapCell = model.tapCell
        self.location = model.location
        
        addTapGesture()
    }
    
    private func addTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(IncomingLocationCell.didTappedCell))
        self.addGestureRecognizer(gesture)
    }
    
    @objc private func didTappedCell() {
        tapCell?(location)
    }
}

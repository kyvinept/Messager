//
//  IncomingAnswerCell.swift
//  Messager
//
//  Created by Silchenko on 19.12.2018.
//

import UIKit

class IncomingAnswerCell: CustomCell {

    @IBOutlet private weak var messageLabel: UILabel!
    private(set) var message: Message?
    
    override func configure(model: CustomViewModel) {
        super.configure(model: model)
        guard let model = model as? AnswerCellViewModel else { return }
        
        messageLabel.text = model.text
        message = model.message
        //timeLabel.text = model.date
    }
}

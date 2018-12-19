//
//  OutgoingAnswerCell.swift
//  Messager
//
//  Created by Silchenko on 19.12.2018.
//

import UIKit

class OutgoingAnswerCell: CustomCell {

    @IBOutlet private weak var messageLabel: UILabel!
    private(set) var message: Message?
    
    override func configure(model: CustomViewModel, answerModel: AnswerViewForCellViewModel?) {
        super.configure(model: model, answerModel: answerModel)
        guard let model = model as? AnswerCellViewModel else { return }
        
        messageLabel.text = model.text
        message = model.message
        //timeLabel.text = model.date
    }
}

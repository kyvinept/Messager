//
//  AnswerViewForCell.swift
//  Messager
//
//  Created by Silchenko on 19.12.2018.
//

import UIKit

class AnswerViewForCell: UIView {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var board: UIView!
    @IBOutlet private weak var borderWidthConstraint: NSLayoutConstraint!
    private var answerMessageWasTapped: ((Message) -> ())?
    private var message: Message?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView = loadViewFromNib(withNibName: "AnswerViewForCell")
        contentView!.frame = bounds
        contentView!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(contentView!)
    }
    
    func configure(model: AnswerViewForCellViewModel) {
        nameLabel.text = model.answerMessage.sender.name
        textLabel.text = model.answerMessage.kind.rawValue
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        answerMessageWasTapped = model.answerMessageWasTapped
        message = model.answerMessage
        
        nameLabel.font = model.nameFont
        nameLabel.textColor = model.nameColor
        textLabel.textColor = model.messageColor
        textLabel.font = model.messageFont
        board.backgroundColor = model.borderColor
        borderWidthConstraint.constant = model.borderWidth
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let message = message {
            answerMessageWasTapped?(message)
        }
    }
}

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
    private var answerMessageWasTapped: ((Message) -> ())?
    private var message: Message?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView = loadViewFromNib()
        contentView!.frame = bounds
        contentView!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(contentView!)
    }
    
    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AnswerViewForCell", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func configure(model: AnswerViewForCellViewModel, withFont font: UIFont) {
        nameLabel.text = model.answerMessage.sender.name
        textLabel.text = model.answerMessage.kind.rawValue
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        answerMessageWasTapped = model.answerMessageWasTapped
        message = model.answerMessage
        textLabel.font = font
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let message = message {
            answerMessageWasTapped?(message)
        }
    }
}

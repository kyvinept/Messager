//
//  AnswerView.swift
//  Messager
//
//  Created by Silchenko on 19.12.2018.
//

import UIKit

class AnswerView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var answerTextLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    private var closeView: (() -> ())?
    private(set) var message: Message?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView = loadViewFromNib(withNibName: "AnswerView")
        contentView!.frame = bounds
        contentView!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(contentView!)
    }
    
    func configure(model: AnswerViewViewModel) {
        closeView = model.closeView
        answerTextLabel.text = model.answerMessage.kind.rawValue
        nameLabel.text = model.answerMessage.sender.name
        message = model.answerMessage
    }
    
    @IBAction private func choseButtonTapped(_ sender: Any) {
        closeView?()
    }
}

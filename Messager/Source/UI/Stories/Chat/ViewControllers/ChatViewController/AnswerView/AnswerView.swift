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
    private var closeView: (() -> ())?
    private(set) var message: Message?
    
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
        let nib = UINib(nibName: "AnswerView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func configure(model: AnswerViewViewModel) {
        //backgroundColor = .clear
        closeView = model.closeView
        answerTextLabel.text = "Text"
        message = model.answerMessage
    }
    
    @IBAction private func choseButtonTapped(_ sender: Any) {
        closeView?()
    }
}

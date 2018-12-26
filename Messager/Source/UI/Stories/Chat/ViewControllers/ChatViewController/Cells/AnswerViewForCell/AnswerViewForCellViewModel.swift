//
//  AnswerViewForCell.swift
//  Messager
//
//  Created by Silchenko on 19.12.2018.
//

import UIKit

struct AnswerViewForCellViewModel {
    
    var answerMessage: Message
    var answerMessageWasTapped: ((Message) -> ())?
    var messageFont: UIFont
    var messageColor: UIColor
    var nameFont: UIFont
    var nameColor: UIColor
    var borderColor: UIColor
    var borderWidth: CGFloat
}

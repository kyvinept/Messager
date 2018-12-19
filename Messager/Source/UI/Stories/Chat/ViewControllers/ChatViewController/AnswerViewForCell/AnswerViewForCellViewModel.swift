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
}

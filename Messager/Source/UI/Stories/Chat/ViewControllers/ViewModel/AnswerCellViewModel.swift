//
//  AnswerCellViewModel.swift
//  Messager
//
//  Created by Silchenko on 19.12.2018.
//

import UIKit

struct AnswerCellViewModel: CustomViewModel {
    
    var userImageUrl: String
    var text: String
    var date: String
    var message: Message
    
    var backgroundColor: UIColor
    
    init(text: String, message: Message, backgroundColor: UIColor) {
        self.userImageUrl = ""
        self.text = text
        self.message = message
        self.date = message.sentDate.toString(dateFormat: "HH:mm")
        self.backgroundColor = backgroundColor
    }
}

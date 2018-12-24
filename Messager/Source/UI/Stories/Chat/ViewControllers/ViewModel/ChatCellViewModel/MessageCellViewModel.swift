//
//  MessageCellViewModel.swift
//  Messager
//
//  Created by Silchenko on 30.10.2018.
//

import UIKit

struct MessageCellViewModel: CustomViewModel {
    
    var inputBubble: UIImage?
    var outputBubble: UIImage?
    var message: String
    var date: String
    var userImageUrl: String
    var backgroundColor: UIColor
    var inputColor: UIColor
    var outputColor: UIColor
    var font: UIFont
    
    init(inputBubble: UIImage?, outputBubble: UIImage?, message: String, date: Date, userImageUrl: String, backgroundColor: UIColor, inputColor: UIColor, outputColor: UIColor, font: UIFont) {
        self.inputBubble = inputBubble
        self.outputBubble = outputBubble
        self.message = message
        self.date = date.toString(dateFormat: "HH:mm")
        self.userImageUrl = userImageUrl
        self.backgroundColor = backgroundColor
        self.inputColor = inputColor
        self.outputColor = outputColor
        self.font = font
    }
}

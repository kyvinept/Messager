//
//  MessageCellViewModel.swift
//  Messager
//
//  Created by Silchenko on 30.10.2018.
//

import UIKit

struct MessageCellViewModel: CustomViewModel {
    
    var message: String
    var date: String
    var userImageUrl: String
    
    var backgroundColor: UIColor
    
    init(message: String, date: Date, userImageUrl: String, backgroundColor: UIColor) {
        self.message = message
        self.date = date.toString(dateFormat: "HH:mm")
        self.userImageUrl = userImageUrl
        self.backgroundColor = backgroundColor
    }
}

//
//  MessageCellViewModel.swift
//  Messager
//
//  Created by Silchenko on 30.10.2018.
//

import UIKit

struct MessageCellViewModel {
    
    var message: String
    var date: String
    var userImageUrl: String
    
    init(message: String, date: Date, userImageUrl: String) {
        self.message = message
        self.date = date.toString(dateFormat: "HH:mm")
        self.userImageUrl = userImageUrl
    }
}

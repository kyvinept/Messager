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
    
    init(message: String, date: Date) {
        self.message = message
        self.date = date.getTime()
    }
}

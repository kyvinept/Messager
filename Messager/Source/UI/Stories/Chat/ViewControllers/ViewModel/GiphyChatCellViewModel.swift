//
//  GiphyChatCellViewModel.swift
//  Messager
//
//  Created by Silchenko on 21.11.2018.
//

import UIKit

struct GiphyChatCellViewModel {
    
    var date: String
    var userImageUrl: String
    var id: String
    var url: String
    
    init(date: Date, userImageUrl: String, id: String, url: String) {
        self.date = date.toString(dateFormat: "HH:mm")
        self.userImageUrl = userImageUrl
        self.id = id
        self.url = url
    }
}

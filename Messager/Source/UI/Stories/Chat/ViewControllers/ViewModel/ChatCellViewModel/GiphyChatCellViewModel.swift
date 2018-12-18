//
//  GiphyChatCellViewModel.swift
//  Messager
//
//  Created by Silchenko on 21.11.2018.
//

import UIKit

struct GiphyChatCellViewModel: CustomViewModel {
    
    var date: String
    var userImageUrl: String
    var giphy: Giphy
    
    init(date: Date, userImageUrl: String, giphy: Giphy) {
        self.date = date.toString(dateFormat: "HH:mm")
        self.userImageUrl = userImageUrl
        self.giphy = giphy
    }
}

//
//  VideoCellViewModel.swift
//  Messager
//
//  Created by Silchenko on 15.11.2018.
//

import UIKit

struct VideoCellViewModel: CustomViewModel {
    
    var date: String
    var userImageUrl: String
    var video: URL
    var downloaded: Bool
    
    init(date: Date, userImageUrl: String, video: URL, downloaded: Bool) {
        self.date = date.toString(dateFormat: "HH:mm")
        self.userImageUrl = userImageUrl
        self.video = video
        self.downloaded = downloaded
    }
}

//
//  ImageCellViewModel.swift
//  Messager
//
//  Created by Silchenko on 30.10.2018.
//

import UIKit

struct ImageCellViewModel: CustomViewModel {
    
    var image: UIImage
    var imageSize: CGSize
    var downloaded: Bool
    var date: String
    var userImageUrl: String
    
    init(image: UIImage, imageSize: CGSize, date: Date, downloaded: Bool, userImageUrl: String) {
        self.image = image
        self.imageSize = imageSize
        self.date = date.toString(dateFormat: "HH:mm")
        self.downloaded = downloaded
        self.userImageUrl = userImageUrl
    }
}

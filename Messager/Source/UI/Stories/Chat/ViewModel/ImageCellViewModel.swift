//
//  ImageCellViewModel.swift
//  Messager
//
//  Created by Silchenko on 30.10.2018.
//

import UIKit

struct ImageCellViewModel {
    
    var image: UIImage
    var imageSize: CGSize
    var downloaded: Bool
    var date: String
    
    init(image: UIImage, imageSize: CGSize, date: Date, downloaded: Bool) {
        self.image = image
        self.imageSize = imageSize
        self.date = date.getTime()
        self.downloaded = downloaded
    }
}

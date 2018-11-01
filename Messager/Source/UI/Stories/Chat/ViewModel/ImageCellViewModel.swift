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
    var date: String
    
    init(image: UIImage, imageSize: CGSize, date: Date) {
        self.image = image
        self.imageSize = imageSize
        self.date = date.toString()
    }
}

//
//  Image.swift
//  Messager
//
//  Created by Silchenko on 19.12.2018.
//

import UIKit

struct Image {
    var image: UIImage?
    var url: String?
    
    var isMyImage: Bool
    
    init(image: UIImage, url: String, isMyImage: Bool) {
        self.image = image
        self.url = url
        self.isMyImage = isMyImage
    }
    
    init(imageModel: Image, image: UIImage) {
        self.url = imageModel.url
        self.isMyImage = imageModel.isMyImage
        self.image = image
    }
    
    init(url: String, isMyImage: Bool) {
        self.url = url
        self.isMyImage = isMyImage
    }
    
    init(image: UIImage, isMyImage: Bool) {
        self.image = image
        self.isMyImage = isMyImage
    }
}

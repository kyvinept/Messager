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
    
    var id: String
    var isMyImage: Bool
    
    init(image: UIImage, url: String, isMyImage: Bool, id: String) {
        self.image = image
        self.url = url
        self.id = id
        self.isMyImage = isMyImage
    }
    
    init(imageModel: Image, image: UIImage, id: String) {
        self.url = imageModel.url
        self.id = id
        self.isMyImage = imageModel.isMyImage
        self.image = image
    }
    
    init(url: String, isMyImage: Bool, id: String) {
        self.url = url
        self.id = id
        self.isMyImage = isMyImage
    }
    
    init(image: UIImage, isMyImage: Bool, id: String) {
        self.image = image
        self.id = id
        self.isMyImage = isMyImage
    }
}

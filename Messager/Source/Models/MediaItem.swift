//
//  ImageMessage.swift
//  Messager
//
//  Created by Silchenko on 25.10.2018.
//

import UIKit

class MediaItem {
    
    var image: UIImage
    var size: CGSize
    var downloaded: Bool
    
    init(image: UIImage, size: CGSize, downloaded: Bool) {
        self.image = image
        self.size = size
        self.downloaded = downloaded
    }
}

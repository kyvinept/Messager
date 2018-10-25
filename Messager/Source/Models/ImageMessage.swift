//
//  ImageMessage.swift
//  Messager
//
//  Created by Silchenko on 25.10.2018.
//

import UIKit
import MessageKit

struct ImageMessage: MediaItem {
    
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

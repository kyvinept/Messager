//
//  UIImage.swift
//  Messager
//
//  Created by Silchenko on 30.10.2018.
//

import UIKit

extension UIImage {
    
    func getSizeForMessage() -> CGSize {
        let imageSize = self.preferredPresentationSizeForItemProvider
        var size: CGSize
        if imageSize.height > imageSize.width {
            size = CGSize(width: UIScreen.main.bounds.width*0.45, height: imageSize.height/imageSize.width*UIScreen.main.bounds.width*0.45)
        } else {
            size = CGSize(width: UIScreen.main.bounds.width*0.75, height: imageSize.height/imageSize.width*UIScreen.main.bounds.width*0.75)
        }
        return size
    }
}

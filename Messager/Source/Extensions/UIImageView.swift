//
//  UIImageView.swift
//  Messager
//
//  Created by Silchenko on 06.11.2018.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    func downloadImage(from url: String, placeholderImage: UIImage? = UIImage(named: "person")) {
        guard let imageUrl = URL(string: url) else { return }
        self.sd_setImage(with: imageUrl, placeholderImage: placeholderImage)
    }
}

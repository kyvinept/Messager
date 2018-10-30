//
//  UICollectionView.swift
//  Messager
//
//  Created by Silchenko on 30.10.2018.
//

import UIKit

extension UICollectionView {
    
    func scrollToBottom(animated: Bool) {
        self.scrollToItem(at: IndexPath(row: numberOfItems(inSection: 0), section: 0), at: .bottom, animated: animated)
    }
}

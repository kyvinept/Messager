//
//  UICollectionView.swift
//  Messager
//
//  Created by Silchenko on 03.12.2018.
//

import UIKit

extension UICollectionView {
    func scrollToLastItem() {
        let lastSection = self.numberOfSections - 1
        let lastRow = self.numberOfItems(inSection: lastSection)
        let indexPath = IndexPath(row: lastRow - 1, section: lastSection)
        self.scrollToItem(at: indexPath, at: .right, animated: true)
    }
}

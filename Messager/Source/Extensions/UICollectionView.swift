//
//  UICollectionView.swift
//  Messager
//
//  Created by Silchenko on 30.10.2018.
//

import UIKit

extension UITableView {
    
    func scrollToBottom(animated: Bool){
        DispatchQueue.main.async {
            if self.numberOfRows(inSection: self.numberOfSections - 1) - 1 >= 0 {
                let indexPath = IndexPath(row: self.numberOfRows(inSection: self.numberOfSections - 1) - 1,
                                      section: self.numberOfSections - 1)
                self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
}

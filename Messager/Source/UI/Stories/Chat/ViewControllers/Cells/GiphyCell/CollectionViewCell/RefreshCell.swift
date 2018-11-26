//
//  RefreshCell.swift
//  Messager
//
//  Created by Silchenko on 26.11.2018.
//

import UIKit

class RefreshCell: UICollectionViewCell {

    @IBOutlet private weak var refreshView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        refreshView.startAnimating()
    }
}

//
//  CustomCellProtocol.swift
//  Messager
//
//  Created by Silchenko on 18.12.2018.
//

import UIKit

protocol CustomCellProtocol {
    func configure(model: CustomViewModel)
}

class CustomCell: UITableViewCell, CustomCellProtocol {
    
    func configure(model: CustomViewModel) {
        
    }
}

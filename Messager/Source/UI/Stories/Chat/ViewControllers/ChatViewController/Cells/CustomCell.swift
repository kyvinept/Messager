//
//  CustomCellProtocol.swift
//  Messager
//
//  Created by Silchenko on 18.12.2018.
//

import UIKit

protocol CustomCellProtocol {
    func configure(model: CustomViewModel, defaultModel: DefaultViewModel, answerModel: AnswerViewForCellViewModel?)
    func changeBackgroundColor(isSearch: Bool)
}

class CustomCell: UITableViewCell, CustomCellProtocol {
    
    func changeBackgroundColor(isSearch: Bool) {
        backgroundColor = isSearch ? UIColor(red: 151.0/255.0, green: 195.0/255.0, blue: 255.0/255.0, alpha: 1) : .clear
    }
    
    func configure(model: CustomViewModel, defaultModel: DefaultViewModel, answerModel: AnswerViewForCellViewModel?) {
        backgroundColor = .clear
    }
}

//
//  ChatViewControllerProtocol.swift
//  Messager
//
//  Created by Silchenko on 20.12.2018.
//

import UIKit

protocol ChatViewControllerProtocol {
    func configureBubble(inputBubble input: UIImage, outputBubble output: UIImage)
    func configure(messageFont: UIFont)
    func configureLocation(withImage image: UIImage, size: CGSize)
    func configure(sendMessageIcon: UIImage, cameraIcon: UIImage, fileIcon: UIImage)
    func configureGiphy(activeStateIcon: UIImage, defaultStateIcon: UIImage)
    func configure(calendarIcon: UIImage, searchToTopIcon: UIImage, searchToBottomIcon: UIImage)
    func configureColorMessage(inputColor: UIColor, outputColor: UIColor)
    func configurePlaceHolder(forInputText text: String)
    func configurePlaceHolder(forSearchGiphy text: String)
    func configurePlaceHolder(forSearchMessage text: String)
    func configureOffsetForUserIcon(toMessage: CGFloat, toBoard: CGFloat)
    func configureTimeLabelColor(forMessage messageColor: UIColor, forMedia mediaColor: UIColor, font: UIFont)
    func configureAnswerMessage(messageFont: UIFont, messageColor: UIColor, nameFont: UIFont, nameColor: UIColor, boardColor: UIColor, boardWidth: CGFloat)
}

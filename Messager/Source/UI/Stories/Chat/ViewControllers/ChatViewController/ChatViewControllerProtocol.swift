//
//  ChatViewControllerProtocol.swift
//  Messager
//
//  Created by Silchenko on 20.12.2018.
//

import UIKit

protocol ChatViewControllerProtocol {
    func changeBubble(inputBubble input: UIImage, outputBubble output: UIImage)
    func change(font: UIFont)
    func changeLocation(withImage image: UIImage, size: CGSize)
    func changeIcons(sendMessage: UIImage, camera: UIImage, files: UIImage)
    func changeGiphyIcons(activeState: UIImage, defaultState: UIImage)
    func changeIcons(calendar: UIImage, searchToTop: UIImage, searchToBottom: UIImage)
    func changeColorMessage(inputColor: UIColor, outputColor: UIColor)
    func changePlaceHolder(forInputText text: String)
    func changePlaceHolder(forSearchGiphy text: String)
    func changePlaceHolder(forSearchMessage text: String)
    func changeOffsetForUserIcon(toMessage: CGFloat, toBoard: CGFloat)
    func changeTimeLabelColor(forMessage messageColor: UIColor, forMedia mediaColor: UIColor, font: UIFont)
}

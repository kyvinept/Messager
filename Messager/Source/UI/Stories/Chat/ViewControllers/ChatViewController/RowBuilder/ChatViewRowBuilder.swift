//
//  ChatViewRowBuilder.swift
//  Messager
//
//  Created by Silchenko on 20.12.2018.
//

import UIKit

class ChatViewRowBuilder {
    
    var selectedAnswerMessage: ((IndexPath) -> ())?
    var didTapLocation: ((CLLocationCoordinate2D) -> ())?
    var messages: [Message]! {
        didSet {
            rowPrototype.messages = messages
        }
    }
    var currentUser: User!
    
    private var tableView: UITableView
    private var rowPrototype = ChatViewRowPrototype()
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func createCell(forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let answerModel = rowPrototype.createAnswerViewForCellViewModel(withMessage: messages[indexPath.row],
                                                                        selectedRow: selectedAnswerMessage)
        let defaultModel = rowPrototype.createDefaultModel()
        
        switch messages[indexPath.row].kind {
        case .text(let text):
            let model = rowPrototype.createMessageModel(forMessage: messages[indexPath.row], withText: text, chooseCell: false)
            return messages[indexPath.row].sender == currentUser ?
                   createCell(indexPath: indexPath, withModel: model, defaultModel: defaultModel, answerModel: answerModel) as OutgoingMessageCell :
                   createCell(indexPath: indexPath, withModel: model, defaultModel: defaultModel, answerModel: answerModel) as IncomingMessageCell

        case .photo(let mediaItem):
            let model = rowPrototype.createImageModel(forMessage: messages[indexPath.row], withMediaItem: mediaItem)
            return messages[indexPath.row].sender == currentUser ?
                   createCell(indexPath: indexPath, withModel: model, defaultModel: defaultModel, answerModel: answerModel) as OutgoingImageCell :
                   createCell(indexPath: indexPath, withModel: model, defaultModel: defaultModel, answerModel: answerModel) as IncomingImageCell

        case .location(let location):
            let model = rowPrototype.createLocationModel(forMessage: messages[indexPath.row],
                                                       withLocation: location,
                                                     didTapLocation: didTapLocation)
            return messages[indexPath.row].sender == currentUser ?
                   createCell(indexPath: indexPath, withModel: model, defaultModel: defaultModel, answerModel: answerModel) as OutgoingLocationCell :
                   createCell(indexPath: indexPath, withModel: model, defaultModel: defaultModel, answerModel: answerModel) as IncomingLocationCell

        case .video(let videoItem):
            let model = rowPrototype.createVideoModel(forMessage: messages[indexPath.row], withVideoItem: videoItem)
            return messages[indexPath.row].sender == currentUser ?
                   createCell(indexPath: indexPath, withModel: model, defaultModel: defaultModel, answerModel: answerModel) as OutgoingVideoCell :
                   createCell(indexPath: indexPath, withModel: model, defaultModel: defaultModel, answerModel: answerModel) as IncomingVideoCell

        case .giphy(let giphy):
            let model = rowPrototype.createGiphyModel(forMessage: messages[indexPath.row], withGiphy: giphy)
            return messages[indexPath.row].sender == currentUser ?
                   createCell(indexPath: indexPath, withModel: model, defaultModel: defaultModel, answerModel: answerModel) as OutgoingGiphyCell :
                   createCell(indexPath: indexPath, withModel: model, defaultModel: defaultModel, answerModel: answerModel) as IncomingGiphyCell
        }
    }
    
    func setDefaultLocation(image: UIImage, size: CGSize) {
        rowPrototype.setDefaultLocation(image: image, size: size)
    }
    
    func setDefaultBubbles(inputBubble input: UIImage, outputBubble output: UIImage) {
        rowPrototype.setDefaultBubbles(inputBubble: input, outputBubble: output)
    }
    
    func setMessageFont(font: UIFont) {
        rowPrototype.setMessageFont(font: font)
    }
    
    func setMessageColor(input: UIColor, output: UIColor) {
        rowPrototype.setMessageColor(input: input, output: output)
    }
    
    func setDefaultOffsetForUserImage(toMessage: CGFloat, toBoard: CGFloat) {
        rowPrototype.setDefaultOffsetForUserImage(toMessage: toMessage, toBoard: toBoard)
    }
    
    func setDefault(timeLabelFont: UIFont, timeLabelColorForMessage: UIColor, timeLabelColorForMedia: UIColor) {
        rowPrototype.setDefault(timeLabelFont: timeLabelFont,
                     timeLabelColorForMessage: timeLabelColorForMessage,
                       timeLabelColorForMedia: timeLabelColorForMedia)
    }
    
    func setDefaultAnswerMessage(messageFont: UIFont, messageColor: UIColor, nameFont: UIFont, nameColor: UIColor, boardColor: UIColor, boardWidth: CGFloat) {
        rowPrototype.setDefaultAnswerMessage(messageFont: messageFont,
                                            messageColor: messageColor,
                                                nameFont: nameFont,
                                               nameColor: nameColor,
                                              boardColor: boardColor,
                                              boardWidth: boardWidth)
    }
}

private extension ChatViewRowBuilder {
    
    func createCell<T: CustomCellProtocol>(indexPath: IndexPath, withModel model: CustomViewModel, defaultModel: DefaultViewModel, answerModel: AnswerViewForCellViewModel?) -> T {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(String(reflecting: T.self).split(separator: ".").last!), for: indexPath) as! T
        cell.configure(model: model, defaultModel: defaultModel, answerModel: answerModel)
        return cell
    }
}

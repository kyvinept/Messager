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
        
        switch messages[indexPath.row].kind {
        case .text(let text):
            let model = rowPrototype.createMessageModel(forMessage: messages[indexPath.row], withText: text, chooseCell: false)
            return messages[indexPath.row].sender == currentUser ?
                   createCell(indexPath: indexPath, withModel: model, answerModel: answerModel) as OutgoingMessageCell :
                   createCell(indexPath: indexPath, withModel: model, answerModel: answerModel) as IncomingMessageCell

        case .photo(let mediaItem):
            let model = rowPrototype.createImageModel(forMessage: messages[indexPath.row], withMediaItem: mediaItem)
            return messages[indexPath.row].sender == currentUser ?
                   createCell(indexPath: indexPath, withModel: model, answerModel: answerModel) as OutgoingImageCell :
                   createCell(indexPath: indexPath, withModel: model, answerModel: answerModel) as IncomingImageCell

        case .location(let location):
            let model = rowPrototype.createLocationModel(forMessage: messages[indexPath.row],
                                                       withLocation: location,
                                                     didTapLocation: didTapLocation)
            return messages[indexPath.row].sender == currentUser ?
                   createCell(indexPath: indexPath, withModel: model, answerModel: answerModel) as OutgoingLocationCell :
                   createCell(indexPath: indexPath, withModel: model, answerModel: answerModel) as IncomingLocationCell

        case .video(let videoItem):
            let model = rowPrototype.createVideoModel(forMessage: messages[indexPath.row], withVideoItem: videoItem)
            return messages[indexPath.row].sender == currentUser ?
                   createCell(indexPath: indexPath, withModel: model, answerModel: answerModel) as OutgoingVideoCell :
                   createCell(indexPath: indexPath, withModel: model, answerModel: answerModel) as IncomingVideoCell

        case .giphy(let giphy):
            let model = rowPrototype.createGiphyModel(forMessage: messages[indexPath.row], withGiphy: giphy)
            return messages[indexPath.row].sender == currentUser ?
                   createCell(indexPath: indexPath, withModel: model, answerModel: answerModel) as OutgoingGiphyCell :
                   createCell(indexPath: indexPath, withModel: model, answerModel: answerModel) as IncomingGiphyCell
        }
    }
    
    func setDefaultLocation(image: UIImage, size: CGSize) {
        rowPrototype.setDefaultLocation(image: image, size: size)
    }
    
    func setDefaultBubbles(inputBubble input: UIImage, outputBubble output: UIImage) {
        rowPrototype.setDefaultBubbles(inputBubble: input, outputBubble: output)
    }
}

private extension ChatViewRowBuilder {
    
    func createCell<T: CustomCellProtocol>(indexPath: IndexPath, withModel model: CustomViewModel, answerModel: AnswerViewForCellViewModel?) -> T {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(String(reflecting: T.self).split(separator: ".").last!), for: indexPath) as! T
        cell.configure(model: model, answerModel: answerModel)
        return cell
    }
}

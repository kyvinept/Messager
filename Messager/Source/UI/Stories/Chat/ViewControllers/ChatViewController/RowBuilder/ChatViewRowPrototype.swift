//
//  ChatViewRowPrototype.swift
//  Messager
//
//  Created by Silchenko on 20.12.2018.
//

import UIKit

class ChatViewRowPrototype {
    
    var messages: [Message]!
    private var locationImage = UIImage(named: "location")
    private var locationImageSize = CGSize(width: 120, height: 57)
    private var inputBubble = UIImage(named: "bubble")
    private var outputBubble = UIImage(named: "bubble1")
    private var inputMessageColor: UIColor = .black
    private var outputMessageColor: UIColor = .black
    private var messageFont = UIFont.systemFont(ofSize: 17)
    private var answerMessageFont: UIFont = UIFont.systemFont(ofSize: 14)
    private var answerMessageColor: UIColor = .black
    private var answerNameFont: UIFont = UIFont.boldSystemFont(ofSize: 12)
    private var answerNameColor: UIColor = .white
    private var answerBoardColor: UIColor = .white
    private var answerBoardWidth: CGFloat = 2
    private var toMessageOffset: CGFloat = 8
    private var toBoardOffset: CGFloat = 8
    private var timeLabelColorForMessage: UIColor = .black
    private var timeLabelColorForMedia: UIColor = .white
    private var timeLabelFont: UIFont = UIFont.systemFont(ofSize: 12)
}

extension ChatViewRowPrototype {
    
    func setDefaultLocation(image: UIImage, size: CGSize) {
        locationImage = image
        locationImageSize = size
    }
    
    func setDefaultBubbles(inputBubble input: UIImage, outputBubble output: UIImage) {
        inputBubble = input
        outputBubble = output
    }
    
    func setMessageColor(input: UIColor, output: UIColor) {
        inputMessageColor = input
        outputMessageColor = output
    }
    
    func setMessageFont(font: UIFont) {
        messageFont = font
    }
    
    func setDefaultAnswerMessage(messageFont: UIFont, messageColor: UIColor, nameFont: UIFont, nameColor: UIColor, boardColor: UIColor, boardWidth: CGFloat) {
        answerNameFont = nameFont
        answerNameColor = nameColor
        answerMessageFont = messageFont
        answerMessageColor = messageColor
        answerBoardColor = boardColor
        answerBoardWidth = boardWidth
    }
    
    func setDefaultOffsetForUserImage(toMessage: CGFloat, toBoard: CGFloat) {
        self.toMessageOffset = toMessage
        self.toBoardOffset = toBoard
    }
    
    func setDefault(timeLabelFont: UIFont, timeLabelColorForMessage: UIColor, timeLabelColorForMedia: UIColor) {
        self.timeLabelColorForMessage = timeLabelColorForMessage
        self.timeLabelColorForMedia = timeLabelColorForMedia
        self.timeLabelFont = timeLabelFont
    }
}

extension ChatViewRowPrototype {
    
    func createAnswerViewForCellViewModel(withMessage message: Message, selectedRow: ((IndexPath) -> ())?) -> AnswerViewForCellViewModel? {
        var answerModel: AnswerViewForCellViewModel? = nil
        if let messageAnswerId = message.answer,
            let message = messages.first(where: { $0.messageId == messageAnswerId }) {
            answerModel = AnswerViewForCellViewModel(answerMessage: message,
                                            answerMessageWasTapped: { [weak self] answerMessage in
                                                                        guard let messageIndex = self?.messages.firstIndex(of: message) else { return }
                                                                        let indexPath = IndexPath(row: messageIndex, section: 0)
                                                                        selectedRow?(indexPath)
                                                                    },
                                                       messageFont: answerMessageFont,
                                                      messageColor: answerMessageColor,
                                                          nameFont: answerNameFont,
                                                         nameColor: answerNameColor,
                                                       borderColor: answerBoardColor,
                                                       borderWidth: answerBoardWidth)
        }
        return answerModel
    }
    
    func createMessageModel(forMessage message: Message, withText text: String, chooseCell: Bool) -> MessageCellViewModel {
        return MessageCellViewModel(inputBubble: inputBubble,
                                   outputBubble: outputBubble,
                                        message: text,
                                           date: message.sentDate,
                                   userImageUrl: message.sender.imageUrl,
                                backgroundColor: chooseCell ? UIColor(red: 151.0/255.0,
                                                                    green: 195.0/255.0,
                                                                     blue: 255.0/255.0,
                                                                    alpha: 1)
                                                            : UIColor.clear,
                                     inputColor: inputMessageColor,
                                    outputColor: outputMessageColor,
                                           font: messageFont)
    }
    
    func createGiphyModel(forMessage message: Message, withGiphy giphy: Giphy) -> GiphyChatCellViewModel {
        return GiphyChatCellViewModel(date: message.sentDate,
                              userImageUrl: message.sender.imageUrl,
                                     giphy: giphy)
    }
    
    func createImageModel(forMessage message: Message, withMediaItem mediaItem: MediaItem) -> ImageCellViewModel {
        return ImageCellViewModel(image: mediaItem.image,
                              imageSize: mediaItem.size,
                                   date: message.sentDate,
                             downloaded: mediaItem.downloaded,
                           userImageUrl: message.sender.imageUrl)
    }
    
    func createVideoModel(forMessage message: Message, withVideoItem videoItem: VideoItem) -> VideoCellViewModel {
        return VideoCellViewModel(date: message.sentDate,
                          userImageUrl: message.sender.imageUrl,
                                 video: videoItem.videoUrl,
                            downloaded: videoItem.downloaded)
    }
    
    func createLocationModel(forMessage message: Message, withLocation location: CLLocationCoordinate2D, didTapLocation: ((CLLocationCoordinate2D) -> ())?) -> LocationCellViewModel {
        return LocationCellViewModel(locationImage: locationImage,
                                 locationImageSize: locationImageSize,
                                              date: message.sentDate,
                                      userImageUrl: message.sender.imageUrl,
                                          location: location,
                                           tapCell: { location in
                                                        didTapLocation?(location)
                                                    })
    }
    
    func createDefaultModel() -> DefaultViewModel {
        return DefaultViewModel(toMessage: toMessageOffset,
                                  toBoard: toBoardOffset,
                 timeLabelColorForMessage: timeLabelColorForMessage,
                   timeLabelColorForMedia: timeLabelColorForMedia,
                            timeLabelFont: timeLabelFont)
    }
}

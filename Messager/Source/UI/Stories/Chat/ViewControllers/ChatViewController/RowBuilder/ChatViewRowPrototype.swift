//
//  ChatViewRowPrototype.swift
//  Messager
//
//  Created by Silchenko on 20.12.2018.
//

import UIKit

class ChatViewRowPrototype {
    
    var messages: [Message]!
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
            })
        }
        return answerModel
    }
    
    func createMessageModel(forMessage message: Message, withText text: String, chooseCell: Bool) -> MessageCellViewModel {
        return MessageCellViewModel(message: text,
                                       date: message.sentDate,
                               userImageUrl: message.sender.imageUrl,
                            backgroundColor: chooseCell ? UIColor(red: 151.0/255.0,
                                                                green: 195.0/255.0,
                                                                 blue: 255.0/255.0,
                                                                alpha: 1)
                                                        : UIColor.clear)
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
        return LocationCellViewModel(date: message.sentDate,
                             userImageUrl: message.sender.imageUrl,
                                 location: location,
                                  tapCell: { location in
                                               didTapLocation?(location)
                                           })
    }
}

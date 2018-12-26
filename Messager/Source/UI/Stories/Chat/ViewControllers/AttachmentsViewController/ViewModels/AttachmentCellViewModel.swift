//
//  AttachmentCellViewModel.swift
//  Messager
//
//  Created by Silchenko on 24.12.2018.
//

import UIKit

struct AttachmentCellViewModel {
    var messageKind: MessageKind
    var showLocation: ((CLLocationCoordinate2D) -> ())?
    var showFullImage: ((UIImage) -> ())?
    var showFullVideo: ((VideoItem) -> ())?
}

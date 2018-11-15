//
//  URL.swift
//  Messager
//
//  Created by Silchenko on 15.11.2018.
//

import UIKit
import AVFoundation

extension URL {
    var sizeForMessage: CGSize? {
        guard let track = AVURLAsset(url: self).tracks(withMediaType: AVMediaType.video).first else { return nil }
        let naturalSize = track.naturalSize.applying(track.preferredTransform)
        
        var size: CGSize
        if naturalSize.height > naturalSize.width {
            size = CGSize(width: UIScreen.main.bounds.width*0.45, height: naturalSize.height/naturalSize.width*UIScreen.main.bounds.width*0.45)
        } else {
            size = CGSize(width: UIScreen.main.bounds.width*0.75, height: naturalSize.height/naturalSize.width*UIScreen.main.bounds.width*0.75)
        }
        return size
    }
}

//
//  VideoItem.swift
//  Messager
//
//  Created by Silchenko on 15.11.2018.
//

import UIKit
import AVFoundation

class VideoItem {
    
    var videoUrl: URL
    var bytes: Int
    var downloaded: Bool
    
    init(videoUrl: URL, downloaded: Bool) {
        self.videoUrl = videoUrl
        self.bytes = AVURLAsset(url: videoUrl).fileSize ?? -1
        self.downloaded = downloaded
    }
}

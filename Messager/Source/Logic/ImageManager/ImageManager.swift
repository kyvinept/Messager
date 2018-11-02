//
//  ImageManager.swift
//  Messager
//
//  Created by Silchenko on 31.10.2018.
//

import UIKit
import Cloudinary

class ImageManager {
    
    private let cloudinaryUrl = "cloudinary://335865959162651:a6r9CrEp64WEkIHihFWGJccYlAA@dfneucqih"
    private var cloudinary: CLDCloudinary!

    init() {
        cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudinaryUrl: cloudinaryUrl)!)
    }
    
    func downloadImage(url: String, progress: @escaping (Double) -> (), completionHandler: @escaping (MessageKind?) -> ()) {
        cloudinary.createDownloader().fetchImage(url, { (progressDownload) in
            progress(progressDownload.fractionCompleted)
            print(progress)
        }, completionHandler: { (image, error) in
            if let image = image {
                completionHandler(MessageKind.photo(MediaItem(image: image, size: image.getSizeForMessage(), downloaded: true)))
            }
        })
    }
    
    func uploadImage(data: Data, progress: @escaping (Double) -> (), completionHandler: @escaping (String?) -> ()) {
        cloudinary.createUploader()
        .signedUpload(data: data,
                    params: nil,
                  progress: { (progress) in
                                print(progress.fractionCompleted)
                            },
         completionHandler: { (result, error) in
                                if let url = result?.url {
                                    completionHandler(url)
                                }
                            })
    }
}

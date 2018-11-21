//
//  GiphyManager.swift
//  Messager
//
//  Created by Silchenko on 15.11.2018.
//

import UIKit
import GiphyCoreSDK

class GiphyManager {
    
    private let ApiKey = "9KSjp5yLfFdc9U24ew7uCwQ89xSUGtNM"
    private var mapper: GiphyMapperProtocol
    
    init(mapper: GiphyMapperProtocol) {
        GiphyCore.configure(apiKey: ApiKey)
        self.mapper = mapper
    }
    
    func getTrendingGiphy(successBlock: @escaping ([Giphy]) -> (), errorBlock: @escaping (Error?) -> ()) {
        GiphyCore.shared.trending { responce, error in
            if let responce = responce {
                successBlock(self.mapper.map(serverGiphy: responce.data!))
            } else {
                errorBlock(error)
            }
        }
    }
    
    func getGiphy(withQuery query: String, successBlock: @escaping ([Giphy]) -> (), errorBlock: @escaping (Error?) -> ()) {
        GiphyCore.shared.search(query) { responce, error in
            if let responce = responce {
                successBlock(self.mapper.map(serverGiphy: responce.data!))
            } else if let error = error {
                errorBlock(error)
            }
        }
    }
}

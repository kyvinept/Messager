//
//  GiphyManager.swift
//  Messager
//
//  Created by Silchenko on 15.11.2018.
//

import UIKit
import GiphyCoreSDK
import Alamofire
import SwiftyJSON

class GiphyManager {
    
    private enum Request: String {
        case search = "/v1/gifs/search"
        case trending = "/v1/gifs/trending"
    }
    
    private let host = "https://api.giphy.com"
    private let ApiKey = "9KSjp5yLfFdc9U24ew7uCwQ89xSUGtNM"
    private let limit = 24
    private var mapper: GiphyMapperProtocol
    private var lastRequest: (String, [String: Any])?

    init(mapper: GiphyMapperProtocol) {
        GiphyCore.configure(apiKey: ApiKey)
        self.mapper = mapper
    }
    
    func getNewItemFromLastRequest(successBlock: @escaping ([Giphy]) -> (), errorBlock: @escaping (Error?) -> ()) {
        guard let lastRequest = lastRequest else {
            errorBlock(nil)
            return
        }
        var dictionary = lastRequest.1
        print(dictionary["offset"])
        dictionary["offset"] = dictionary["offset"]! as! Int + limit
        print(dictionary["offset"])
        Alamofire.request(lastRequest.0, method: .get, parameters: dictionary, encoding: URLEncoding.queryString, headers: nil).responseJSON { responce in
            self.lastRequest = (lastRequest.0, dictionary)
            do {
                guard let data = responce.data else { return }
                let json = try JSON(data: data)
                successBlock(self.mapper.map(jsonGiphy: json))
            } catch {
                print("no json")
            }
        }
    }
    
    func getTrendingGiphy(pageNumber: Int, successBlock: @escaping ([Giphy]) -> (), errorBlock: @escaping (Error?) -> ()) {
        let dictionary: Parameters = ["api_key": ApiKey, "limit": limit, "offset": pageNumber * limit, "fmt": "json"]
        let url = getUrl(request: .trending)
        Alamofire.request(url, method: .get, parameters: dictionary, encoding: URLEncoding.queryString, headers: nil).responseJSON { responce in
            self.lastRequest = (url, dictionary)
            do {
                guard let data = responce.data else { return }
                let json = try JSON(data: data)
                successBlock(self.mapper.map(jsonGiphy: json))
            } catch {
                print("no json")
            }
        }
    }
    
    func getGiphy(withQuery query: String, pageNumber: Int, successBlock: @escaping ([Giphy]) -> (), errorBlock: @escaping (Error?) -> ()) {
        let dictionary: Parameters = ["api_key": ApiKey, "q": query, "limit": limit, "offset": pageNumber * limit, "fmt": "json"]
        let url = getUrl(request: .search)
        Alamofire.request(url, method: .get, parameters: dictionary, encoding: URLEncoding.queryString, headers: nil).responseJSON { responce in
            self.lastRequest = (url, dictionary)
            do {
                guard let data = responce.data else { return }
                let json = try JSON(data: data)
                successBlock(self.mapper.map(jsonGiphy: json))
            } catch {
                print("no json")
            }
        }
    }
    
    private func getUrl(request: Request) -> String {
        return host + request.rawValue
    }
}

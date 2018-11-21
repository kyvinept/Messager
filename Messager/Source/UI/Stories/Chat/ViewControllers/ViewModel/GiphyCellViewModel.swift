//
//  GiphyCellViewModel.swift
//  Messager
//
//  Created by Silchenko on 16.11.2018.
//

import UIKit

struct GiphyCellViewModel {

    var id: String
    var url: String
    var choseGiphy: ((String, String) -> ())?
    
    init(id: String, url: String, choseGiphy: ((String, String) -> ())?) {
        self.id = id
        self.url = url
        self.choseGiphy = choseGiphy
    }
}

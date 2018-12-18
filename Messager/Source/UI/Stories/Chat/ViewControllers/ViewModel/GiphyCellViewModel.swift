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
    var previewGiphy: ((String) -> ())?
    var endPreviewGiphy: (() -> ())?
    
    init(id: String, url: String, choseGiphy: ((String, String) -> ())?, previewGiphy: ((String) -> ())?, endPreviewGiphy: @escaping (() -> ())) {
        self.id = id
        self.url = url
        self.choseGiphy = choseGiphy
        self.previewGiphy = previewGiphy
        self.endPreviewGiphy = endPreviewGiphy
    }
}

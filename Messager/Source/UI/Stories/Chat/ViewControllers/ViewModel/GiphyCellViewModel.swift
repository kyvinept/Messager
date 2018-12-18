//
//  GiphyCellViewModel.swift
//  Messager
//
//  Created by Silchenko on 16.11.2018.
//

import UIKit

struct GiphyCellViewModel {

    var giphy: Giphy
    var choseGiphy: ((Giphy) -> ())?
    var previewGiphy: ((String) -> ())?
    var endPreviewGiphy: (() -> ())?
    
    init(giphy: Giphy, choseGiphy: ((Giphy) -> ())?, previewGiphy: ((String) -> ())?, endPreviewGiphy: @escaping (() -> ())) {
        self.giphy = giphy
        self.choseGiphy = choseGiphy
        self.previewGiphy = previewGiphy
        self.endPreviewGiphy = endPreviewGiphy
    }
}

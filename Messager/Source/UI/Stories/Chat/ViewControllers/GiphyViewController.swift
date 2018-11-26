//
//  GiphyViewController.swift
//  Messager
//
//  Created by Silchenko on 16.11.2018.
//

import UIKit
import JGProgressHUD

protocol GiphyViewControllerDelegate: class {
    
    func didTappedGetTrendingGiphy(pageNumber: Int, successBlock: @escaping ([Giphy]) -> (), viewController: GiphyViewController)
    func didShowActivityIndicator(viewController: GiphyViewController, successBlock: @escaping ([Giphy]) -> (), errorBlock: @escaping (Error?) -> ())
}

class GiphyViewController: UIViewController {
    
    weak var delegate: GiphyViewControllerDelegate?
    var choseGiphy: ((String, String) -> ())?
    private var giphy = [Giphy]()
    @IBOutlet private weak var collectionView: UICollectionView!
    private(set) var pageNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTrendingGiphy(pageNumber: pageNumber)
        collectionView.register(UINib(nibName: "GiphyCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView.register(UINib(nibName: "RefreshCell", bundle: nil), forCellWithReuseIdentifier: "RefreshCell")
        collectionView.reloadData()
    }
    
    func configure(giphy: [Giphy]) {
        DispatchQueue.main.async {
            if self.giphy.count > 0 {
                self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
            self.giphy = giphy
            if let collectionView = self.collectionView {
                collectionView.reloadData()
            }
        }
    }
    
    func addNewGiphy(giphy: [Giphy]) {
        for giphyElement in giphy {
            self.giphy.append(giphyElement)
        }
        DispatchQueue.main.async {
            if let collectionView = self.collectionView {
                collectionView.reloadData()
            }
        }
    }
}

extension GiphyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return giphy.count > 0 ? giphy.count+1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < giphy.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GiphyCell
            cell.configure(model: GiphyCellViewModel(id: giphy[indexPath.row].id,
                                                    url: giphy[indexPath.row].url,
                                             choseGiphy: { id, url in
                                                             self.choseGiphy?(url, id)
                                                         }))
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RefreshCell", for: indexPath) as! RefreshCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row < giphy.count {
            return CGSize(width: self.view.frame.width/4, height: self.view.frame.width/4)
        } else {
            return CGSize(width: self.view.frame.width, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == giphy.count - 1 {
            delegate?.didShowActivityIndicator(viewController: self,
                                                 successBlock: { newGiphy in
                                                                    DispatchQueue.main.async {
                                                                        for giphyElement in newGiphy {
                                                                            self.giphy.append(giphyElement)
                                                                        }
                                                                        self.collectionView.reloadData()
                                                                    }
                                                               },
                                                   errorBlock: { error in
                                                                    print("Error add new element")
                                                               })
        }
    }
}

private extension GiphyViewController {
    
    func getTrendingGiphy(pageNumber: Int) {
        delegate?.didTappedGetTrendingGiphy(pageNumber: pageNumber,
                                          successBlock: { giphy in
                                                            self.configure(giphy: giphy)
                                                        },
                                        viewController: self)
    }
}

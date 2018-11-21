//
//  GiphyViewController.swift
//  Messager
//
//  Created by Silchenko on 16.11.2018.
//

import UIKit

protocol GiphyViewControllerDelegate: class {
    
    func didTappedGetTrendingGiphy(successBlock: @escaping ([Giphy]) -> (), viewController: GiphyViewController)
}

class GiphyViewController: UIViewController {
    
    weak var delegate: GiphyViewControllerDelegate?
    var choseGiphy: ((String, String) -> ())?
    private var giphy = [Giphy]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTrendingGiphy()
        collectionView.register(UINib(nibName: "GiphyCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView.reloadData()
    }
    
    func configure(giphy: [Giphy]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.giphy = giphy
            self.collectionView.reloadData()
        }
    }
}

extension GiphyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return giphy.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GiphyCell
        cell.configure(model: GiphyCellViewModel(id: giphy[indexPath.row].id,
                                                url: giphy[indexPath.row].url,
                                         choseGiphy: { id, url in
                                                         self.choseGiphy?(url, id)
                                                     }))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/4, height: self.view.frame.width/4)
    }
}

private extension GiphyViewController {
    
    func getTrendingGiphy() {
        delegate?.didTappedGetTrendingGiphy(successBlock: { giphy in
                                                              self.giphy = giphy
                                                              DispatchQueue.main.async {
                                                                  if let collectionView = self.collectionView{
                                                                      collectionView.reloadData()
                                                                  }
                                                              }
                                                          },
                                          viewController: self)
    }
}

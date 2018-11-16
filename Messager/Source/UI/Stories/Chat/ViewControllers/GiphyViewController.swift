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
    private var giphy = [Giphy]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTrendingGiphy()
        collectionView.reloadData()
        collectionView.register(UINib(nibName: "OutgoingGiphyCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    }
}

extension GiphyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return giphy.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! OutgoingGiphyCell
        cell.configure(model: GiphyCellViewModel(id: giphy[indexPath.row].id,
                                                url: giphy[indexPath.row].url))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/4, height: self.view.frame.width/4)
    }
}

private extension GiphyViewController {
    
    private func getTrendingGiphy() {
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

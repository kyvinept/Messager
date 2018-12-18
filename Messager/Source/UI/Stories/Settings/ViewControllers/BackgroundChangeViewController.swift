//
//  BackgroundChangeViewController.swift
//  Messager
//
//  Created by Silchenko on 18.12.2018.
//

import UIKit

protocol BackgroundChangeViewControllerDelegate: class {
    func didTappedCancelButton(viewController: UIViewController)
    func didTappedImage(_ image: UIImage, viewController: UIViewController)
}

class BackgroundChangeViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    private var images = [UIImage]()
    
    weak var delegate: BackgroundChangeViewControllerDelegate?
    
    func addImage(image: UIImage) {
        guard !images.contains(image) else { return }
        images.append(image)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func addYourImagesButtonTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction private func cancelButtonTapped(_ sender: Any) {
        delegate?.didTappedCancelButton(viewController: self)
    }
}

extension BackgroundChangeViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if images.count > 0 {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
            pageControl.currentPage = 0
        }
        images.insert(image, at: 0)
        collectionView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension BackgroundChangeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = images.count
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let difference = view.frame.height / collectionView.frame.height
        let image = UIImageView(frame: CGRect(origin: cell.frame.origin,
                                                size: CGSize(width: collectionView.frame.width * difference,
                                                            height: collectionView.frame.height)))
        image.image = images[indexPath.row]
        image.contentMode = .scaleAspectFit
        cell.backgroundView = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTappedImage(images[indexPath.row], viewController: self)
        
        let alert = UIAlertController(title: "Success",
                                    message: "Image add to chat background. Return to settings or change another background?",
                             preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Another", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Return", style: .destructive, handler: { action in
            self.delegate?.didTappedCancelButton(viewController: self)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

//
//  BackgroundChangeViewController.swift
//  Messager
//
//  Created by Silchenko on 18.12.2018.
//

import UIKit

protocol BackgroundChangeViewControllerDelegate: class {
    func didTappedCancelButton(viewController: UIViewController)
    func didAddNewImage(_ image: UIImage, currentUser: User, viewController: UIViewController)
    func didTappedImage(_ image: UIImage, viewController: UIViewController)
}

class BackgroundChangeViewController: UIViewController {

    @IBOutlet private weak var optionShowImage: UISegmentedControl!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    private var images = [Image]()
    private var allImages = [Image]()
    private var currentUser: User?
    
    weak var delegate: BackgroundChangeViewControllerDelegate?
    
    func addImage(image: Image) {
        guard !allImages.contains(where: { $0.image == image.image }) else { return }
        allImages.append(image)
        images = allImages
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func configure(currentUser: User) {
        self.currentUser = currentUser
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateWidth()
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
    
    @IBAction func optionShowImageValueChanged(_ sender: Any) {
        switch optionShowImage.selectedSegmentIndex {
        case 0:
            images = allImages
        case 1:
            images = allImages
            images.removeAll(where: { !$0.isMyImage })
        default:
            break
        }
        if images.count > 0 {
            scrollToFirstItem()
        }
        collectionView.reloadData()
    }
}

private extension BackgroundChangeViewController {
    
    func calculateWidth() {
        let difference = collectionView.frame.height / view.frame.height
        collectionView.frame.size.width = view.frame.width * difference
    }
    
    func scrollToFirstItem() {
        pageControl.currentPage = 0
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
    }
}

extension BackgroundChangeViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        if let currentUser = currentUser {
            delegate?.didAddNewImage(image, currentUser: currentUser, viewController: self)
        }
        
        if images.count > 0 {
            scrollToFirstItem()
        }
        images.insert(Image(image: image, isMyImage: true), at: 0)
        allImages.insert(Image(image: image, isMyImage: true), at: 0)
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
        let image = UIImageView(frame: cell.frame)
        image.image = images[indexPath.row].image
        image.contentMode = .scaleAspectFill
        cell.backgroundView = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let image = images[indexPath.row].image else { return }
        delegate?.didTappedImage(image, viewController: self)
        
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

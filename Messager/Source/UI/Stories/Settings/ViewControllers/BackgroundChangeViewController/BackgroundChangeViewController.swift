//
//  BackgroundChangeViewController.swift
//  Messager
//
//  Created by Silchenko on 18.12.2018.
//

import UIKit

protocol BackgroundChangeViewControllerDelegate: class {
    func didTappedCancelButton(viewController: UIViewController)
    func didAddNewImage(_ image: Image, currentUser: User, viewController: UIViewController)
    func didTappedImage(_ image: Image, viewController: UIViewController)
}

class BackgroundChangeViewController: UIViewController {

    @IBOutlet private weak var optionShowImage: UISegmentedControl!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var noImagesLabel: UILabel!
    @IBOutlet private weak var pageControl: UIPageControl!
    private var images = [Image]()
    private var allImages = [Image]()
    private var currentUser: User?
    private var currentImage: Image?
    
    weak var delegate: BackgroundChangeViewControllerDelegate?
    
    func addImage(image: Image) {
        guard !allImages.contains(where: { $0.image == image.image }) else { return }
        
        DispatchQueue.main.async {
            self.allImages.append(image)
            self.images.append(image)
            self.collectionView.reloadData()
            if let currentImage = self.currentImage,
               let index = self.images.firstIndex(where: { $0.id == currentImage.id }) {
                self.pageControl.currentPage = index
                self.collectionView.scrollToItem(at: IndexPath(row: index, section: 0),
                                                 at: .centeredHorizontally,
                                           animated: true)
            }
        }
    }
    
    func configure(currentUser: User, image: Image?) {
        self.currentUser = currentUser
        currentImage = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateWidth()
        setValueForLayout()
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
        if images.count > 0 {
            scrollToFirstItem()
        }
        switch optionShowImage.selectedSegmentIndex {
        case 0:
            images = allImages
        case 1:
            images = allImages
            images.removeAll(where: { !$0.isMyImage })
        default:
            break
        }
        collectionView.reloadData()
    }
}

private extension BackgroundChangeViewController {
    
    func setValueForLayout() {
        let flow = CarouselFlowLayout()
        collectionView.collectionViewLayout = flow
        flow.changeIndex = { [weak self] index in
            self?.pageControl.currentPage = index
        }
    }
    
    func calculateWidth() {
        let difference = collectionView.frame.height / view.frame.height
        collectionView.frame.size.width = view.frame.width * difference
    }
    
    func scrollToFirstItem() {
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
        pageControl.currentPage = 0
    }
}

extension BackgroundChangeViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let newImage = Image(image: image, isMyImage: true, id: UUID().uuidString)
        if let currentUser = currentUser {
            delegate?.didAddNewImage(newImage, currentUser: currentUser, viewController: self)
        }
        
        if images.count > 0 {
            scrollToFirstItem()
        }
        images.insert(newImage, at: 0)
        allImages.insert(newImage, at: 0)
        collectionView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension BackgroundChangeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        noImagesLabel.isHidden = images.count > 0
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
        showAlert(image: images[indexPath.row])
    }

    private func showAlert(image: Image) {
        let alert = UIAlertController(title: "Success",
                                      message: "Are you sure you want to apply the selected picture?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Apply", style: .default, handler: { action in
            self.delegate?.didTappedImage(image, viewController: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

//
//  FullImageViewController.swift
//  Messager
//
//  Created by Silchenko on 26.12.2018.
//

import UIKit
import FacebookShare

protocol FullImageViewControllerDelegate: class {
    func didTappedShareToFacebookButton(image: UIImage, viewController: FullImageViewController)
    func didTappedShareToMailButton(image: UIImage, viewController: FullImageViewController)
}

class FullImageViewController: UIViewController {

    @IBOutlet private weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageView: UIImageView!
    private var image: UIImage?
    private var isShowNavigationBar = true
    
    weak var delegate: FullImageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = image {
            setImage(image)
        }
        setGesture()
        addShareButton()
    }
    
    func configure(image: UIImage) {
        self.image = image
        guard let _ = imageView else { return }
        setImage(image)
    }
}

private extension FullImageViewController {
    func addShareButton() {
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(FullImageViewController.shareButtonTapped))
        navigationItem.rightBarButtonItem = share
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
        let size = image.size
        imageViewWidthConstraint.constant = view.frame.width
        imageViewHeightConstraint.constant = size.height / size.width * view.frame.width
    }
    
    func setGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(FullImageViewController.imageWasTapped))
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(FullImageViewController.scaleImage))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(FullImageViewController.panImage))
        imageView.addGestureRecognizer(tap)
        imageView.addGestureRecognizer(pinch)
        imageView.addGestureRecognizer(pan)
    }
    
    @objc func imageWasTapped() {
        view.backgroundColor = isShowNavigationBar ? .darkGray : .white
        navigationController?.setNavigationBarHidden(isShowNavigationBar, animated: true)
        isShowNavigationBar.toggle()
    }
    
    @objc func scaleImage(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .began {
            hideNavigationBar()
            imageView.center = view.center
        }
        if gesture.state == .changed {
            imageView.transform = imageView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
            gesture.scale = 1
        }
        if gesture.state == .ended && imageView.transform.a < 1 && imageView.transform.d < 1 {
            UIView.animate(withDuration: 0.2) {
                self.imageView.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: 0)
            }
        }
    }
    
    @objc func panImage(_ gesture: UIPanGestureRecognizer) {
        guard imageView.transform.a > 1 && imageView.transform.d > 1 else { return }
        if gesture.state == .began {
            hideNavigationBar()
        }
        if gesture.state == .changed {
            let translation = gesture.translation(in: view)
            imageView.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
            alignImage()
            gesture.setTranslation(CGPoint.zero, in: view)
        }
    }
    
    @objc func shareButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "To Facebook",
                                      style: .default,
                                    handler: { [weak self] _ in
                                                  guard let strongSelf = self, let image = strongSelf.image else { return }
                                                  strongSelf.delegate?.didTappedShareToFacebookButton(image: image,
                                                                                             viewController: strongSelf)
                                             }))
        alert.addAction(UIAlertAction(title: "To Mail",
                                      style: .default,
                                    handler: { [weak self] _ in
                                                  guard let strongSelf = self, let image = strongSelf.image else { return }
                                                  strongSelf.delegate?.didTappedShareToMailButton(image: image,
                                                                                         viewController: strongSelf)
                                             }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func hideNavigationBar() {
        view.backgroundColor = .darkGray
        navigationController?.setNavigationBarHidden(true, animated: true)
        isShowNavigationBar = false
    }
    
    func alignImage() {
        if imageView.frame.origin.x + imageView.frame.width < view.frame.width && imageView.frame.origin.x > 0 {
            imageView.center.x = view.center.x
        } else if imageView.frame.origin.x > 0 {
            imageView.frame.origin.x = 0
        } else if imageView.frame.origin.x + imageView.frame.width < view.frame.width {
            imageView.frame.origin.x = view.frame.width - imageView.frame.width
        }
        
        if imageView.frame.origin.y + imageView.frame.height < view.frame.height && imageView.frame.origin.y > 0 {
            imageView.center.y = view.center.y
        } else if imageView.frame.origin.y > 0 {
            imageView.frame.origin.y = 0
        } else if imageView.frame.origin.y + imageView.frame.height < view.frame.height {
            imageView.frame.origin.y = view.frame.height - imageView.frame.height
        }
    }
}

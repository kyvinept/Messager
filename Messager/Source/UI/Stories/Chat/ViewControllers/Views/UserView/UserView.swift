//
//  UserView.swift
//  Messager
//
//  Created by Silchenko on 24.12.2018.
//

import UIKit

class UserView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    private var model: UserViewViewModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView = loadViewFromNib(withNibName: "UserView")
        contentView!.frame = bounds
        contentView!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(contentView!)
        setGesture()
    }
    
    func configure(model: UserViewViewModel) {
        imageView.downloadImage(from: model.userImageUrl)
        nameLabel.text = model.userName
        self.model = model
    }
    
    @IBAction private func backButtonTapped(_ sender: Any) {
        model.backButtonTapped?()
    }
    
    @IBAction private func searchButtonTapped(_ sender: Any) {
        model.searchButtonTapped?()
    }
    
    private func setGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UserView.viewWasTapped))
        addGestureRecognizer(tap)
    }
    
    @objc private func viewWasTapped() {
        model.userProfileTapped?()
    }
}

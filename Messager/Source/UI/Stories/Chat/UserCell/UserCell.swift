//
//  UserCell.swift
//  Messager
//
//  Created by Silchenko on 29.10.2018.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var lastMessageLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(model: UserCellViewModel) {
        self.userImage.image = model.userImage
        self.nameLabel.text = model.userName
        self.lastMessageLabel.text = model.lastMessage
        self.timeLabel.text = model.lastMessageTime
    }
}

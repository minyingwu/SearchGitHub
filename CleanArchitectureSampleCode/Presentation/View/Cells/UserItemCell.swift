//
//  UserItemCell.swift
//  CleanArchitectureSampleCode
//
//  Created by Victor on 2021/3/11.
//

import UIKit
import Kingfisher

class UserItemCell: UICollectionViewCell, Configurable {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    func configure(_ item: UserItem) -> Self {
        self.userNameLabel.text = item[keyPath: \.login]
        self.userAvatarImageView.kf.setImage(with: URL(string: item[keyPath: \.avatarURL]))
        return self
    }
    
}

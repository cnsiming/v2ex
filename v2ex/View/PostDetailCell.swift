//
//  PostDetailCell.swift
//  v2ex
//
//  Created by wjb on 2018/3/7.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit
import Kingfisher

class PostDetailCell: UITableViewCell {

    var avatarUrl: String? {
        didSet {
            if let avatarUrl = avatarUrl, let url = URL(string: avatarUrl) {
                avatar.kf.setImage(with: url)
            }
        }
    }

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var footer: UILabel!
    @IBOutlet weak var node: UILabel!
    @IBOutlet weak var content: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        avatar.layer.cornerRadius = 8
        avatar.layer.masksToBounds = true
    }

}

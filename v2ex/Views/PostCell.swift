//
//  PostCell.swift
//  v2ex
//
//  Created by wjb on 2018/3/6.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    var avatarUrl: String? {
        didSet {
            if let avatarUrl = avatarUrl, let url = URL(string: avatarUrl) {
                avatar.kf.setImage(with: url)
            }
        }
    }

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var node: UILabel!
    @IBOutlet weak var updateTime: UILabel!
    @IBOutlet weak var comments: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        avatar.image = nil
        title.text = nil
        username.text = nil
        node.text = nil
        updateTime.text = nil
        comments.text = nil

        avatar.layer.cornerRadius = avatar.frame.width / 2
        avatar.layer.masksToBounds = true
        avatar.layer.shouldRasterize = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        avatar.image = nil
        title.text = nil
        username.text = nil
        node.text = nil
        updateTime.text = nil
        comments.text = nil
    }
}

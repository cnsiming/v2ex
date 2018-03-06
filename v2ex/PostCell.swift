//
//  PostCell.swift
//  v2ex
//
//  Created by wjb on 2018/3/6.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var node: UILabel!
    @IBOutlet weak var updateTime: UILabel!
    @IBOutlet weak var comments: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        avatar.layer.cornerRadius = 6
        avatar.layer.masksToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        avatar.image = nil
        title.text = nil
        username.text = nil
        updateTime.text = nil
        comments.text = nil
    }
}

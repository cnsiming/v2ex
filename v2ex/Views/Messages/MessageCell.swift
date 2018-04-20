//
//  MessageCell.swift
//  v2ex
//
//  Created by wjb on 2018/4/12.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit
import Kingfisher

class MessageCell: UITableViewCell {

    var avatarUrl: String? {
        didSet {
            if let avatarUrl = avatarUrl, let url = URL(string: avatarUrl) {
                avatar.kf.setImage(with: url)
            }
        }
    }

//    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var comment: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        avatar.layer.cornerRadius = avatar.frame.width / 2
        avatar.layer.masksToBounds = true
        avatar.layer.shouldRasterize = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.avatar.image = nil
        self.time.text = nil
        self.title.text = nil
        self.comment.text = nil
    }

}

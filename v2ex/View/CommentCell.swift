//
//  CommentCell.swift
//  v2ex
//
//  Created by wjb on 2018/3/8.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    var avatarUrl: String? {
        didSet {
            if let avatarUrl = avatarUrl, let url = URL(string: avatarUrl) {
                avatar.kf.setImage(with: url)
            }
        }
    }
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var floor: UILabel!
    @IBOutlet weak var content: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        avatar.layer.cornerRadius = avatar.frame.width / 2
        avatar.layer.masksToBounds = true
    }


}

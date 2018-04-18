//
//  MyCommentCell.swift
//  v2ex
//
//  Created by wjb on 2018/4/4.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit

class MyCommentCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var comment: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()

        self.title.text = nil
        self.comment.text = nil
    }
}

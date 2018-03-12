//
//  NodeCell.swift
//  v2ex
//
//  Created by wjb on 2018/3/10.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit

class NodeCell: UICollectionViewCell {
    
    @IBOutlet weak var nodeName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        nodeName.layer.cornerRadius = nodeName.frame.height / 2
        nodeName.layer.masksToBounds = true
    }

}

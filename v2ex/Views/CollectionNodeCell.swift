//
//  CollectionNodeCell.swift
//  v2ex
//
//  Created by wjb on 2018/4/3.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit

class CollectionNodeCell: UICollectionViewCell {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var comments: UILabel!

    var logoUrl: String? {
        didSet {
            if let logoUrl = logoUrl, let url = URL(string: logoUrl) {
                logo.kf.setImage(with: url)
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        logo.image = nil
        name.text = nil
        comments.text = nil
        logoUrl = nil
    }

}

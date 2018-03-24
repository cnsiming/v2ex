//
//  SideMenuViewController.swift
//  v2ex
//
//  Created by wjb on 2018/3/22.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit
import Kingfisher

class SideMenuViewController: UIViewController {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var balance: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        avatar.layer.cornerRadius = 36
        avatar.layer.masksToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }

    class func storyboardInstance() -> SideMenuViewController {
        let storyboard = UIStoryboard.init(name: "SideMenu", bundle: nil)
        return storyboard.instantiateInitialViewController() as! SideMenuViewController
    }

    private func refresh() {
        if User.shared.isLogin {
            loginButton.isHidden = true
            username.text = User.shared.username
            balance.text = User.shared.balance
            if let urlString = User.shared.avatar, let url = URL(string: urlString) {
                avatar.kf.setImage(with: url)
            }
        } else {
            loginButton.isHidden = false
            loginButton.bringSubview(toFront: avatar)
            username.text = ""
            balance.text = ""
            avatar.image = nil
        }
    }

}

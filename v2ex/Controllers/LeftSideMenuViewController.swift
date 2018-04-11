//
//  LeftSideMenuViewController.swift
//  v2ex
//
//  Created by wjb on 2018/3/22.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit
import Kingfisher

class LeftSideMenuViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var balance: UILabel!

    private let myPages: [(page: PageType, title: String)] = [
        (.collection(.favoriteNodes), "节点收藏"),
        (.collection(.favoritePosts), "主题收藏"),
        (.collection(.following), "特别关注"),
        (.my(.posts("/member/username/topics")), "我的发帖"),
        (.my(.comments("/member/username/replies")), "我的回复")
    ]
    private let others = ["退出登录"]

    override func viewDidLoad() {
        super.viewDidLoad()

        avatar.layer.cornerRadius = 36
        avatar.layer.masksToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }

    class func storyboardInstance() -> LeftSideMenuViewController {
        let storyboard = UIStoryboard.init(name: "LeftSideMenu", bundle: nil)
        return storyboard.instantiateInitialViewController() as! LeftSideMenuViewController
    }

    private func refresh() {
        let user = User.shared

        if user.isLogin {
            loginButton.isHidden = true
            username.text = user.username
            balance.text = user.balance
            if let urlString = user.avatar, let url = URL(string: urlString) {
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

    private func open(page: PageType, title: String) {
        if let containerVC = self.parent as? ContainerViewController,
            let navVC = containerVC.tabBarVC.viewControllers?.first as? UINavigationController,
            let homeVC = navVC.viewControllers.first as? HomeViewController
        {
            containerVC.toggleRightSideMenu()
            switch page {
            case .collection(.favoriteNodes):
                homeVC.performSegue(withIdentifier: "ShowCollectionNodes", sender: nil)
            case .my(.comments(_)):
                homeVC.performSegue(withIdentifier: "ShowMyComments", sender: nil)
            default:
                homeVC.pageType = page
                homeVC.navigationItem.title = title
            }
        }
    }

}

extension LeftSideMenuViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return myPages.count
        } else {
            return others.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftSideMenuCell", for: indexPath) as! LeftSideMenuCell
        if indexPath.section == 0 {
            cell.name.text = myPages[indexPath.row].title
        } else if indexPath.section == 1 {
            cell.name.text = others[indexPath.row]
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !User.shared.isLogin {
            let alert = UIAlertController(title: "请先登录", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            present(alert, animated: true, completion: nil)
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                User.logout()
                refresh()
            }
        } else if let username = User.shared.username {
            var page = myPages[indexPath.row]

            switch page.page {
            case .my(.posts(let url)):
                page.page = .my(.posts(url.replacingOccurrences(of: "username", with: username)))
            case .my(.comments(let url)):
                page.page = .my(.comments(url.replacingOccurrences(of: "username", with: username)))
            default:
                break
            }

            open(page: page.page, title: page.title)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

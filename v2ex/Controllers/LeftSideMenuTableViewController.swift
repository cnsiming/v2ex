//
//  LeftSideMenuTableViewController.swift
//  v2ex
//
//  Created by wjb on 2018/4/2.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit

class LeftSideMenuTableViewController: UITableViewController {

    private let myPages: [(page: PageType, title: String)] = [
        (.collection(.favoriteNodes), "节点收藏"),
        (.collection(.favoritePosts), "主题收藏"),
        (.collection(.following), "特别关注"),
        (.my(.posts("/member/username/topics")), "我的发帖"),
        (.my(.comments("/member/username/replies")), "我的回复")
    ]

    private func open(page: PageType, title: String) {
        if let containerVC = self.parent?.parent as? ContainerViewController,
            let navVC = containerVC.tabBarVC.viewControllers?.first as? UINavigationController,
            let homeVC = navVC.viewControllers.first as? HomeViewController
        {
            containerVC.toggleRightSideMenu()
            switch page {
            case .collection(.favoriteNodes), .my(.comments(_)):
                break
            default:
                homeVC.pageType = page
                homeVC.navigationItem.title = title
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftSideMenuCell", for: indexPath) as! LeftSideMenuCell
        cell.name.text = myPages[indexPath.row].title

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if User.shared.isLogin, let username = User.shared.username {
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
        } else {
            let alert = UIAlertController(title: "请先登录", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

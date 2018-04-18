//
//  RightSideMenuViewController.swift
//  v2ex
//
//  Created by wjb on 2018/3/30.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit

class RightSideMenuViewController: UITableViewController {

    private let tabs: [(tab: PageType.Tab, title: String)] = [
        (.all, "全部"),
        (.tech, "技术"),
        (.creative, "创意"),
        (.play, "好玩"),
        (.apple, "Apple"),
        (.jobs, "酷工作"),
        (.deals, "交易"),
        (.city, "城市"),
        (.qna, "问与答"),
        (.hot, "最热"),
        (.r2, "R2"),
        (.nodes, "节点"),
        (.members, "关注")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    class func storyboardInstance() -> UITableViewController {
        let storyboard = UIStoryboard(name: "RightSideMenu", bundle: nil)
        return (storyboard.instantiateInitialViewController() as! UITableViewController)
    }

    private func open(tab: PageType.Tab, title: String) {
        if let containerVC = self.parent as? ContainerViewController,
            let navVC = containerVC.tabBarVC.viewControllers?.first as? UINavigationController,
            let homeVC = navVC.viewControllers.first as? PostListViewController
        {
            containerVC.toggleRightSideMenu()
            homeVC.pageType = .home(tab)
            homeVC.navigationItem.title = "V2EX"
            homeVC.navigationItem.rightBarButtonItem?.title = title
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TabCell", for: indexPath)
        cell.textLabel?.text = tabs[indexPath.row].title

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tab = tabs[indexPath.row]
        open(tab: tab.tab, title: tab.title)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

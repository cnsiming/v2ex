//
//  NotificationsViewController.swift
//  v2ex
//
//  Created by wjb on 2018/4/12.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {

    private var currentPage = 1
    private var notifications = [Notification]()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "系统提醒"

        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl!.attributedTitle = NSAttributedString(string: "下拉刷新...")
        tableView.refreshControl!.addTarget(self, action: #selector(refresh), for: .valueChanged)

        refresh()
    }

    @objc private func refresh() {
        currentPage = 1

        Notification.getNotificationList { [weak self] notifications in
            self?.notifications = notifications
            self?.tableView.reloadData()
            self?.tableView.refreshControl?.endRefreshing()
        }
    }

    private func loadNextPage() {
        Notification.getNotificationList(page: currentPage + 1) { [weak self] notifications in
            if notifications.count > 0 {
                self?.currentPage += 1
                self?.notifications.append(contentsOf: notifications)
                self?.tableView.reloadData()
            }
        }
    }

}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        let notification = notifications[indexPath.row]

        cell.avatarUrl = notification.avatar
        cell.time.text = notification.time
        cell.title.text = notification.title
        cell.comment.text = notification.comment

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == notifications.count - 1 {
            loadNextPage()
        }
    }
}

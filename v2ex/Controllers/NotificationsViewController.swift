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
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl!.attributedTitle = NSAttributedString(string: "下拉刷新...")
        tableView.refreshControl!.addTarget(self, action: #selector(refresh), for: .valueChanged)

        refresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.isHidden = !User.shared.isLogin
        loginButton.isHidden = User.shared.isLogin
        refresh()
    }

    @objc private func refresh() {
        guard User.shared.isLogin else {
            return
        }

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

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPostDetail" {
            let postDetailVC = segue.destination as! PostDetailViewController
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                let post = Post()
                post.url = notifications[indexPath.row].url
                post.title = notifications[indexPath.row].title
                postDetailVC.post = post
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

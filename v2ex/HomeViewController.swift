//
//  ViewController.swift
//  v2ex
//
//  Created by wjb on 2018/3/2.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    var posts = [Post]()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        Post.getPostList(of: "all") { results in
            self.posts = results
            self.tableView.reloadData()
        }

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
    }

    private func configure(cell: UITableViewCell, for indexPath: IndexPath) {
        guard let cell = cell as? PostCell else {
            return
        }
        let post = posts[indexPath.row]
        if let avatar = post.avatar, let url = URL(string: "https:\(avatar)") {
            cell.avatar.kf.setImage(with: url)
        }
        cell.title.text = post.title
        cell.username.text = post.username
        if let node = post.nodeName {
            cell.node.text = "🏷 " + node
        }
        if let commentTime = post.commentTime {
            cell.updateTime.text = "🕘 " + commentTime
        }
        if let comments = post.commentCount {
            cell.comments.text = "✉️ " + comments
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        configure(cell: cell, for: indexPath)

        return cell
    }

}


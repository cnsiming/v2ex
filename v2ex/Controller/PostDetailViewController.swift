//
//  PostDetailViewController.swift
//  v2ex
//
//  Created by wjb on 2018/3/7.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {

    var post: Post?
    var postDetail: PostDetail?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200

        if let url = post?.url {
            PostDetail.getPostDetail(url: url) { detail in
                self.postDetail = detail
                self.tableView.reloadData()
            }
        }

        // 隐藏多余的分割线
//        tableView.tableFooterView = UIView()
    }

    func configure(cell: UITableViewCell, for indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = cell as! PostDetailCell
            cell.avatarUrl = postDetail?.avatar
            cell.title.text = post?.title
            cell.footer.text = postDetail?.footer
            if let node = post?.nodeName {
                cell.node.text = "🏷 " + node
            }
            cell.content.text = postDetail?.content
        }
    }

}

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailCell", for: indexPath) as! PostDetailCell
        configure(cell: cell, for: indexPath)
        return cell
    }
}

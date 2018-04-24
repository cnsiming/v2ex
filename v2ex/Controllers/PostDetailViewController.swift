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
    var currentPage = 1

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
        } else {
            navigationItem.rightBarButtonItem = nil
        }

        // 隐藏多余的分割线
        tableView.tableFooterView = UIView()
    }

    func configure(cell: UITableViewCell, for indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = cell as! PostDetailCell
            cell.avatarUrl = postDetail?.avatar
            cell.title.text = postDetail?.title ?? post?.title
            cell.footer.text = postDetail?.footer
            if let node = postDetail?.node {
                cell.node.text = "🏷 " + node
            }
            cell.content.text = postDetail?.content
        } else {
            let cell = cell as! CommentCell
            let comment = postDetail?.comments[indexPath.row - 1]
            cell.avatarUrl = comment?.avatar
            cell.username.text = comment?.username
            cell.time.text = comment?.time
            cell.floor.text = "  \(indexPath.row)  "
            cell.content.text = comment?.content
        }
    }

    private func loadNextPage() {
        PostDetail.getPostDetail(url: post!.url!, page: currentPage + 1) { [weak self] results in
            guard let comments = results?.comments, comments.count > 0 else {
                return
            }

            self?.currentPage += 1
            self?.postDetail?.comments.append(contentsOf: comments)
            self?.postDetail?.commentCount = results!.commentCount
            self?.tableView.reloadData()
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewComment" {
            let newCommentVC = segue.destination as! NewCommentViewController
            newCommentVC.post = post
            newCommentVC.delegate = self
        }
    }

}

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let postDetail = postDetail {
            return postDetail.comments.count + 1
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailCell", for: indexPath)
            configure(cell: cell, for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
            configure(cell: cell, for: indexPath)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == postDetail?.comments.count, currentPage < postDetail!.commentCount / 100 + 1 {
            loadNextPage()
        }
    }

}

extension PostDetailViewController: NewCommentViewControllerDelegate {

    func newCommentViewControllerDidCancel(_ controller: NewCommentViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    func newCommentViewController(_ controller: NewCommentViewController, didFinishSubmitting comment: String) {
        controller.dismiss(animated: true) {
            let hudView = HUDView.hud(inView: self.view, hudType: .finish)
            hudView.text = "回复成功"
        }
    }
}

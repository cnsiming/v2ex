//
//  MyCommentsViewController.swift
//  v2ex
//
//  Created by wjb on 2018/4/7.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit

class MyCommentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var comments = [MyComment]()
    private var currentPage = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl!.attributedTitle = NSAttributedString(string: "下拉刷新...")
        tableView.refreshControl!.addTarget(self, action: #selector(refresh), for: .valueChanged)

        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension

        refresh()
    }

    @objc private func refresh() {
        currentPage = 1

        MyComment.getCommentList(page: currentPage) { [weak self] comments in
            self?.comments = comments
            self?.tableView.reloadData()
            self?.tableView.refreshControl?.endRefreshing()
        }
    }

    private func loadNextPage() {
        MyComment.getCommentList(page: currentPage + 1) { [weak self] comments in
            guard comments.count > 0 else {
                return
            }

            self?.comments.append(contentsOf: comments)
            self?.tableView.reloadData()
            self?.currentPage += 1
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPostDetail" {
            guard let indexPath = tableView.indexPath(for: sender as! MyCommentCell), let url = comments[indexPath.row].url else {
                return
            }

            let postDetailVC = segue.destination as! PostDetailViewController
            let post = Post()
            post.url = baseURL + url
            postDetailVC.post = post
        }
    }

}

extension MyCommentsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCommentCell", for: indexPath) as! MyCommentCell
        let comment = comments[indexPath.row]

        cell.title.text = comment.title
        if let time = comment.time, let comment = comment.comment {
            cell.comment.text = "\(time): \(comment)"
        }

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == comments.count - 1 {
            loadNextPage()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



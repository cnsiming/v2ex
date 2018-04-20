//
//  PostListViewController.swift
//  v2ex
//
//  Created by wjb on 2018/3/2.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit
import Kingfisher

class PostListViewController: UIViewController {

    var posts = [Post]()
    var pageType: PageType = .home(.all) {
        didSet {
            refresh()
        }
    }
    private var currentPage = 1


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    @IBAction func toggleLeftSideMenu(_ sender: UIBarButtonItem) {
        let containerVC = self.navigationController?.parent?.parent as! ContainerViewController
        containerVC.toggleLeftSideMenu()
    }

    @IBAction func toggleRightSideMenu(_ sender: UIBarButtonItem) {
        let containerVC = self.navigationController?.parent?.parent as! ContainerViewController
        containerVC.toggleRightSideMenu()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl!.attributedTitle = NSAttributedString(string: "下拉刷新...")
        tableView.refreshControl!.addTarget(self, action: #selector(refresh), for: .valueChanged)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80

        NotificationCenter.default.addObserver(self, selector: #selector(dailyMission), name: Notification.Name.V2ex.dailyMission, object: nil)

        refresh()
    }

    @objc private func refresh() {
        currentPage = 1
        
        Post.getPostList(from: pageType) { [weak self] results in
            self?.posts = results
            self?.tableView.reloadData()
            self?.tableView.refreshControl!.endRefreshing()
        }
    }

    private func loadNextPage() {
        tableView.tableFooterView?.isHidden = false
        loadingIndicator.startAnimating()

        Post.getPostList(from: pageType, pageNum: currentPage + 1) { [weak self] results in
            if results.count > 0 {
                self?.currentPage += 1
                self?.posts.append(contentsOf: results)
                self?.tableView.reloadData()
            }
            self?.tableView.tableFooterView?.isHidden = true
            self?.loadingIndicator.stopAnimating()
        }
    }

    private func configure(cell: UITableViewCell, for indexPath: IndexPath) {
        guard let cell = cell as? PostCell else {
            return
        }

        let post = posts[indexPath.row]
        cell.avatarUrl = post.avatar
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

    @objc private func dailyMission() {
        let hudView = HUDView.hud(inView: view, animated: true)
        hudView.text = "已签到"
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPostDetail" {
            let postDetailVC = segue.destination as! PostDetailViewController
            if let indexPath = tableView.indexPath(for: sender as! PostCell) {
                postDetailVC.post = posts[indexPath.row]
            }
        }
    }

}

extension PostListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        configure(cell: cell, for: indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == posts.count - 1 {
            switch pageType {
            // BUG: 我的发帖、收藏主题不满一页时，会循环显示
            case .home(.all), .node(_), .collection(_), .my(_):
                loadNextPage()
            default:
                tableView.tableFooterView?.isHidden = true
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}


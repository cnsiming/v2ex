//
//  ViewController.swift
//  v2ex
//
//  Created by 武 on 2018/3/2.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var posts = [Post]()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        Post.getPostList(of: "all") { results in
            self.posts = results
            self.tableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! UITableViewCell
        cell.textLabel?.text = posts[indexPath.row].title ?? ""

        return cell
    }

}


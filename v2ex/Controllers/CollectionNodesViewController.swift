//
//  CollectionNodesViewController.swift
//  v2ex
//
//  Created by wjb on 2018/4/3.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit

class CollectionNodesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var nodes = [Node]()

    override func viewDidLoad() {
        super.viewDidLoad()

        Node.getCollection { [weak self] nodes in
            self?.nodes = nodes
            self?.collectionView.reloadData()
        }
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNodeDetail" {
            let homeVC = segue.destination as! HomeViewController
            let indexPath = collectionView.indexPath(for: sender as! CollectionNodeCell)!
            let node = nodes[indexPath.row]

            homeVC.pageType = .node(node)
            homeVC.navigationItem.leftBarButtonItem = nil
            homeVC.navigationItem.rightBarButtonItem = nil
            homeVC.title = node.name
        }
    }

}

extension CollectionNodesViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nodes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let node = nodes[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionNodeCell", for: indexPath) as! CollectionNodeCell

        cell.logoUrl = node.logo
        cell.name.text = node.name
        cell.comments.text = node.comments

        return cell
    }
    
}

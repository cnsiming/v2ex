//
//  NodeListViewController.swift
//  
//
//  Created by wjb on 2018/3/9.
//

import UIKit

class NodeListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private var nodes = [NodeType]()

    override func viewDidLoad() {
        super.viewDidLoad()

        nodes = NodeType.loadDefaultNodes()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNodeDetail" {
            let homeVC = segue.destination as! HomeViewController
            let indexPath = collectionView.indexPath(for: sender as! UICollectionViewCell)!
            homeVC.node = nodes[indexPath.section].nodes![indexPath.row]
        }
    }

}

extension NodeListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return nodes.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nodes[section].nodes!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NodeCell", for: indexPath) as! NodeCell
        cell.nodeName.text = nodes[indexPath.section].nodes?[indexPath.row].name
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NodeListHeader", for: indexPath) as! NodeListHeaderView
            headerView.nodeType.text = nodes[indexPath.section].type
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
}

extension NodeListViewController: UICollectionViewDelegateFlowLayout {
    // 根据label.text的内容设置UICollectionViewCell的宽度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let nodeName = nodes[indexPath.section].nodes?[indexPath.row].name as NSString? {
            let size = nodeName.size(withAttributes: [NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 15)!])
            return CGSize(width: size.width + 16, height: size.height + 16)
        }
        return CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

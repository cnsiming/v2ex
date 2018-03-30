//
//  ContainerViewController.swift
//  v2ex
//
//  Created by wjb on 2018/3/22.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    var leftSideMenuVC: UIViewController
    var rightSideMenuVC: UITableViewController
    var tabBarVC: UITabBarController

    let leftWidth: CGFloat = UIScreen.main.bounds.width * 0.8
    let rightWidth: CGFloat = 100
    let animationDuration: TimeInterval = 0.5

    var position: Position = .center
    enum Position {
        case left
        case center
        case right
    }

    init(leftSideMenu: UIViewController, rightSideMenu: UITableViewController, tabBar: UITabBarController) {
        self.leftSideMenuVC = leftSideMenu
        self.rightSideMenuVC = rightSideMenu
        self.tabBarVC = tabBar

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildViewController(leftSideMenuVC)
        view.addSubview(leftSideMenuVC.view)
        leftSideMenuVC.didMove(toParentViewController: self)

        addChildViewController(rightSideMenuVC)
        view.addSubview(rightSideMenuVC.view)
        rightSideMenuVC.didMove(toParentViewController: self)

        addChildViewController(tabBarVC)
        view.addSubview(tabBarVC.view)
        leftSideMenuVC.didMove(toParentViewController: self)

        leftSideMenuVC.view.frame = CGRect(x: -leftWidth, y: 0, width: leftWidth, height: view.frame.height)
        rightSideMenuVC.view.frame = CGRect(x: view.frame.width, y: 0, width: rightWidth, height: view.frame.height)
    }

    func toggleLeftSideMenu() {
        switch self.position {
        case .center:
            self.position = .left
        default:
            self.position = .center
        }

        UIView.animate(withDuration: animationDuration) {
            self.setMenu()
        }
    }

    func toggleRightSideMenu() {
        switch position {
        case .center:
            position = .right
        default:
            position = .center
        }

        UIView.animate(withDuration: animationDuration) {
            self.setMenu()
        }
    }

    private func setMenu() {
        switch position {
        case .left:
            leftSideMenuVC.view.frame.origin.x = 0
            tabBarVC.view.frame.origin.x = leftWidth
        case .center:
            leftSideMenuVC.view.frame.origin.x = -leftWidth
            rightSideMenuVC.view.frame.origin.x = view.frame.width
            tabBarVC.view.frame.origin.x = 0
        case .right:
            rightSideMenuVC.view.frame.origin.x = view.frame.width - rightWidth
            tabBarVC.view.frame.origin.x = -rightWidth
        }
    }

}

//
//  ContainerViewController.swift
//  v2ex
//
//  Created by wjb on 2018/3/22.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    var sideMenuViewController: UIViewController
    var tabBarViewController: UITabBarController

    let menuWidth: CGFloat = UIScreen.main.bounds.width * 0.8
    let animationDuration: TimeInterval = 0.5

    var isOpening = false

    init(sideMenu: UIViewController, tabBar: UITabBarController) {
        self.sideMenuViewController = sideMenu
        self.tabBarViewController = tabBar

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildViewController(sideMenuViewController)
        view.addSubview(sideMenuViewController.view)
        sideMenuViewController.didMove(toParentViewController: self)

        addChildViewController(tabBarViewController)
        view.addSubview(tabBarViewController.view)
        sideMenuViewController.didMove(toParentViewController: self)

        sideMenuViewController.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: view.frame.height)
    }

    func toggleSideBar() {
        UIView.animate(withDuration: animationDuration, animations: {
            self.setMenu()
        }) { _ in
            self.isOpening = !self.isOpening
        }
    }

    private func setMenu() {
        if isOpening {
            sideMenuViewController.view.frame.origin.x = -menuWidth
            tabBarViewController.view.frame.origin.x = 0
        } else {
            sideMenuViewController.view.frame.origin.x = 0
            tabBarViewController.view.frame.origin.x = menuWidth
        }
    }

}

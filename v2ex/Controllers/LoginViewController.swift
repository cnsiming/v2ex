//
//  LoginViewController.swift
//  v2ex
//
//  Created by wjb on 2018/3/21.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import UIKit
import Kingfisher

class LoginViewController: UITableViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var captcha: UITextField!
    @IBOutlet weak var captchaImg: UIImageView!

    private var once: String? {
        didSet {
            if let once = once {
                loadImage(once)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        User.login { [weak self] once in
            self?.once = once
        }

    }

    @IBAction func login(_ sender: UIButton) {
        guard let username = username.text, !username.isEmpty else {
            return
        }
        guard let password = password.text, !password.isEmpty else {
            return
        }
        guard let captcha = captcha.text, !captcha.isEmpty else {
            return
        }


        User.login(username, password: password, captcha: captcha, once: once!) { [weak self] success in
            if success {
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }

    private func loadImage(_ once: String) {
        if let url = URL(string: baseURL + "/_captcha?once=" + once) {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self?.captchaImg.image = UIImage(data: data)
                    }
                }
            })
            task.resume()
        }
    }

}

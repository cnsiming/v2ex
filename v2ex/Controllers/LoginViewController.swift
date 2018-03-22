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

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var captchaTextField: UITextField!
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

        usernameTextField.delegate = self
        passwordTextField.delegate = self
        captchaTextField.delegate = self

        User.login { [weak self] once in
            self?.once = once
        }

    }

    @IBAction func login(_ sender: UIButton) {
        guard let username = usernameTextField.text, !username.isEmpty else {
            usernameTextField.becomeFirstResponder()
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            passwordTextField.becomeFirstResponder()
            return
        }
        guard let captcha = captchaTextField.text, !captcha.isEmpty else {
            captchaTextField.becomeFirstResponder()
            return
        }


        User.login(username, password: password, captcha: captcha, once: once!) { [weak self] (success, error) in
            if success {
                self?.dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "登录失败", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "确认", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func close() {
        dismiss(animated: true, completion: nil)
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//
//  User.swift
//  v2ex
//
//  Created by wjb on 2018/3/2.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import Alamofire
import Kanna

var loginParams = [
    "username": "",
    "password": "",
    "captcha": "",
    "once": "once",
    "next": "next"
]

class User {
    var username = ""
    var avatarMini = ""
    var avatarNormal = ""
    var avatarLarge = ""

    class func login(completion: @escaping (String?) -> Void) {
        let url = baseURL + "/signin"

        Alamofire.request(url).validate().responseString { response in
            guard let html = response.result.value else {
                return
            }
            var once: String?
            do {
                let doc = try HTML(html: html, encoding: .utf8)
                once = doc.xpath("//*[@name='once'][1]").first?["value"]
                loginParams["username"] = doc.xpath("//*[@id='Main']/div[2]/div[2]/form/table/tr[1]/td[2]/input").first?["name"] ?? "username"
                loginParams["password"] = doc.xpath("//*[@id='Main']/div[2]/div[2]/form/table/tr[2]/td[2]/input").first?["name"] ?? "password"
                loginParams["captcha"] = doc.xpath("//*[@id='Main']/div[2]/div[2]/form/table/tr[3]/td[2]/input").first?["name"] ?? "captcha"
            } catch let error as NSError {
                print(error.userInfo)
            }
            completion(once)
        }
    }

    class func login(_ username: String, password: String, captcha: String, once: String, completion: @escaping (Bool, String) -> Void) {
        let url = baseURL + "/signin"
        let params: Parameters = [
            loginParams["username"]!: username,
            loginParams["password"]!: password,
            loginParams["captcha"]!: captcha,
            "once": once,
            "next": "/"
        ]
        let headers = ["Host":"www.v2ex.com","Origin":"http://www.v2ex.com","Referer":"http://www.v2ex.com/signin","User-Agent":"Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/32.0.1700.107 Chrome/32.0.1700.107 Safari/537.36"]

        Alamofire.request(url, method: .post, parameters: params, headers: headers).validate().responseString { response in
            var success = false
            var error = "登录异常，请重试"
            if let html = response.result.value {
                print(html)
                do {
                    let doc = try HTML(html: html, encoding: .utf8)
                    // 页面显示“x条未读提醒”则证明登录成功
                    if let _ = doc.xpath("//a[@href='/notifications']").first?.content {
                        success = true
                    } else if let problem = doc.xpath("//div[@class='problem']/ul/li").first?.content {
                        error = problem
                    }
                } catch let error as NSError {
                    print(error.userInfo)
                }
            }
            completion(success, error)
        }
    }

}

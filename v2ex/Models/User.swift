//
//  User.swift
//  v2ex
//
//  Created by wjb on 2018/3/2.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import Alamofire
import Kanna

fileprivate var loginParams = [
    "username": "",
    "password": "",
    "captcha": "",
    "once": "once",
    "next": "next"
]

struct User {

    static var shared = User()

    var username: String? = nil
    var avatar: String? = nil
    var once: String? = nil    // once只能使用一次，使用后需要重新获取
    var isLogin: Bool = false
    var balance : String? = nil

    static func login(completion: @escaping (String?) -> Void) {
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

    static func login(_ username: String, password: String, captcha: String, once: String, completion: @escaping (Bool, String) -> Void) {
        let url = baseURL + "/signin"
        let params: Parameters = [
            loginParams["username"]!: username,
            loginParams["password"]!: password,
            loginParams["captcha"]!: captcha,
            loginParams["once"]!: once,
            loginParams["next"]!: "/"
        ]
        let headers = [
            "Host": "www.v2ex.com",
            "Origin": "http://www.v2ex.com",
            "Referer": "http://www.v2ex.com/signin",
            "User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36"
        ]

        Alamofire.request(url, method: .post, parameters: params, headers: headers).validate().responseString { response in
            var error = "登录异常，请重试"
            if let html = response.result.value {
                do {
                    let doc = try HTML(html: html, encoding: .utf8)
                    // 页面右侧显示用户头像则证明登录成功
                    if let img = doc.xpath("//*[@id='Rightbar']/div[2]/div[1]/table[1]/tr/td[1]/a/img").first?["src"] {
                        shared.isLogin = true
                        shared.username = username
                        shared.avatar = "https:\(img)".replacingOccurrences(of: "normal", with: "large")
                        if let gold = doc.xpath("//a[@class='balance_area']/text()[1]").first?.content,
                            let silver = doc.xpath("//a[@class='balance_area']/text()[2]").first?.content,
                            let bronze = doc.xpath("//a[@class='balance_area']/text()[3]").first?.content {
                                shared.balance = "🥇\(gold)🥈\(silver)🥉\(bronze)"
                        }

                        shared.saveUserInfo()
                    } else if let problem = doc.xpath("//div[@class='problem']/ul/li").first?.content {
                        error = problem
                    }
                } catch let error as NSError {
                    print(error.userInfo)
                }
            }
            completion(shared.isLogin, error)
        }
    }

    static func logout() {
        let storage = HTTPCookieStorage.shared
        if let cookies = storage.cookies {
            for cookie in cookies {
                storage.deleteCookie(cookie)
            }
        }

        shared = User()
        shared.saveUserInfo()
    }

    func saveUserInfo() {
        let userInfo: [String: Any] = [
            "username" : username ?? "",
            "avatar": avatar ?? "",
            "once": once ?? "",
            "isLogin": isLogin,
            "balance": balance ?? ""
        ]
        let userDefaults = UserDefaults.standard
        userDefaults.setValuesForKeys(userInfo)
        userDefaults.synchronize()
    }

    mutating func getFromStorage(){
        let userDefaults = UserDefaults.standard

        self.username = userDefaults.string(forKey: "username")
        self.avatar = userDefaults.string(forKey: "avatar")
        self.once = userDefaults.string(forKey: "once")
        self.isLogin = userDefaults.bool(forKey: "isLogin")
        self.balance = userDefaults.string(forKey: "balance")
    }

}

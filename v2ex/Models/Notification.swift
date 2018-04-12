//
//  Notification.swift
//  v2ex
//
//  Created by wjb on 2018/4/12.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import Alamofire
import Kanna

struct Notification {

    var username: String?
    var avatar: String?
    var time: String?
    var title: String?
    var comment: String?

    init?(html: String) {
        do {
            let doc = try HTML(html: html, encoding: .utf8)
            guard let avatar = doc.xpath("//img[@class='avatar']").first?["src"] else {
                return nil
            }
            self.avatar = "https:\(avatar)"
            self.username = doc.xpath("//table/tr/td[2]/span[1]/a[1]/strong").first?.content
            self.time = doc.xpath("//table/tr/td[2]/span[2]").first?.content
            self.title = doc.xpath("//table/tr/td[2]/span[1]").first?.content
            self.comment = doc.xpath("//div[@class='payload']").first?.content
        } catch let error as NSError {
            print(error.userInfo)
            return nil
        }
    }

    static func getNotificationList(page: Int = 1, completion: @escaping ([Notification]) -> Void) {
        var notifications = [Notification]()
        let url = baseURL + "/notifications"
        let params = ["p": page]
        let headers = ["User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36"]

        Alamofire.request(url, parameters: params, headers: headers).validate().responseString { response in
            guard let html = response.result.value else {
                completion(notifications)
                return
            }

            do {
                let doc = try HTML(html: html, encoding: .utf8)
                for element in doc.xpath("//div[@id='Main']/div[@class='box']/div[@class='cell']") {
                    if let notification = Notification(html: element.toHTML!) {
                        notifications.append(notification)
                    }
                }
            } catch let error as NSError {
                print(error.userInfo)
            }

            completion(notifications)
        }
    }
}

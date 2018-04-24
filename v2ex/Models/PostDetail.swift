//
//  PostDetail.swift
//  v2ex
//
//  Created by wjb on 2018/3/7.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import Alamofire
import Kanna

class PostDetail {
    var title: String?
    var node: String?
    var avatar: String?
    var footer: String?
    var content: String?
    var commentCount = 0
    var comments = [Comment]()

    init(by html: String) {
        do {
            let doc = try HTML(html: html, encoding: .utf8)
            self.title = doc.xpath("//h1").first?.content
            self.node = doc.xpath("//div[@class='header']/a[2]").first?.content
            self.avatar = "https:" + (doc.xpath("//*[@id='Main']/div[2]/div[1]/div[1]/a/img").first?["src"] ?? "")
            self.footer = doc.xpath("//*[@id='Main']/div[2]/div[1]/small").first?.content
            self.content = doc.xpath("//*[@class='topic_content']").first?.content
            if let description = doc.xpath("//*[@id='Main']/div[4]/div[1]/span/text()[1]").first?.content {
                self.commentCount = Int(description.split(separator: " ")[0]) ?? 0
            }

            // 读取最新的once，回帖时使用
            User.shared.once = doc.xpath("//input[@name='once']").first?["value"]

            for element in doc.xpath("//*[@id='Main']/div[4]/*/table") {
                if let comment = Comment(by: element.toHTML!) {
                    self.comments.append(comment)
                }
            }
        } catch let error as NSError {
            print(error.userInfo)
        }
    }

    class func getPostDetail(url: String, page: Int = 1, complition: @escaping (PostDetail?) -> Void) {
        let params = ["p": page]
        let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36"
        var postDetail: PostDetail?
        Alamofire.request(url, parameters: params, headers: ["User-Agent": userAgent]).validate().responseString { response in
            if let html = response.result.value {
                postDetail = PostDetail(by: html)
            }
            complition(postDetail)
        }
    }
}

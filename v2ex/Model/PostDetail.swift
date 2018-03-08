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
    var avatar: String?
    var footer: String?
    var content: String?
    var comments = [Comment]()

    init(by html: String) {
        do {
            let doc = try HTML(html: html, encoding: .utf8)
            self.avatar = "https:" + (doc.xpath("//*[@id='Main']/div[2]/div[1]/div[1]/a/img").first?["src"] ?? "")
            self.footer = doc.xpath("//*[@id='Main']/div[2]/div[1]/small").first?.content
            self.content = doc.xpath("//*[@class='topic_content']").first?.content
            for element in doc.xpath("//*[@id='Main']/div[4]/*/table") {
                if let comment = Comment(by: element.toHTML!) {
                    self.comments.append(comment)
                }
            }
        } catch let error as NSError {
            print(error.userInfo)
        }
    }

    class func getPostDetail(url: String, complition: @escaping (PostDetail?) -> Void) {
        let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36"
        var postDetail: PostDetail?
        Alamofire.request(url, method: .get, headers: ["User-Agent": userAgent]).validate().responseString { response in
            if let html = response.result.value {
                postDetail = PostDetail(by: html)
            }
            complition(postDetail)
        }
    }
}

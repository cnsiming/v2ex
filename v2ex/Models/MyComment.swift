//
//  MyComment.swift
//  v2ex
//
//  Created by wjb on 2018/4/4.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import Alamofire
import Kanna

struct MyComment {

    var username: String?
    var title: String?
    var node: String?
    var time: String?
    var comment: String?
    var url: String?

    init?(postHtml: String, commentHtml: String) {
        do {
            let postDoc = try HTML(html: postHtml, encoding: .utf8)
            let commentDoc = try HTML(html: commentHtml, encoding: .utf8)
            
            self.username = postDoc.xpath("//table/tr[1]/td/span/a[1]").first?.content
            self.title = postDoc.xpath("//table/tr[1]/td/span/a[3]").first?.content
            self.node = postDoc.xpath("//table/tr[1]/td/span/a[2]").first?.content
            self.time = postDoc.xpath("//table/tr[1]/td/div/span").first?.content
            self.url = postDoc.xpath("//table/tr[1]/td/span/a[3]").first?["href"]
            self.comment = commentDoc.xpath("//div").first?.content
        } catch let error as NSError {
            print(error.userInfo)
        }
    }

    static func getCommentList(page: Int = 1, completion: @escaping ([MyComment]) -> Void) {
        var myComments = [MyComment]()

        guard let username = User.shared.username else {
            completion(myComments)
            return
        }

        let url = baseURL + "/member/\(username)/replies"
        let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36"
        let params = ["p": page]

        Alamofire.request(url, parameters: params, encoding: URLEncoding.default, headers: ["User-Agent": userAgent]).validate().responseString { response in
            if let html = response.result.value {
                do {
                    let doc = try HTML(html: html, encoding: .utf8)
                    let posts = doc.xpath("//div[@class='dock_area']")
                    let comments = doc.xpath("//div[@class='reply_content']")

                    // 主题和回复数量不一致时，页面解析错误，先返回空
                    guard posts.count == comments.count else {
                        completion([])
                        return
                    }

                    for index in 0..<posts.count {
                        if let myComment = MyComment(postHtml: posts[index].toHTML!, commentHtml: comments[index].toHTML!) {
                            myComments.append(myComment)
                        }
                    }
                } catch let error as NSError {
                    print(error.userInfo)
                }

                completion(myComments)
            }
        }
    }
}

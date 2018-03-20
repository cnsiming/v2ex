//
//  Post.swift
//  v2ex
//
//  Created by wjb on 2018/3/2.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

//import Foundation
import Kanna
import Alamofire

let baseURL = "https://www.v2ex.com"

class Post {
    var url: String?
    var avatar: String?
    var title: String?
    var nodeName: String?
    var nodeURL: String?
    var username: String?
    var commentTime: String?
    var commentUser: String?
    var commentCount: String?

    init?(html: String, isFromNode: Bool) {
        var timeXpath = "//table/tr/td[3]/span[2]/text()[3]"
        if isFromNode {
            timeXpath = "//table/tr/td[3]/span[2]/text()"
        }

        do {
            let doc = try HTML(html: html, encoding: .utf8)

            // 如果获取不到标题，就跳过
            if let title = doc.xpath("//table/tr/td[3]/span[1]/a").first?.content {
                self.title = title
            } else {
                return nil
            }
            if let url = doc.xpath("//table/tr/td[3]/span[1]/a").first?["href"] {
                self.url = baseURL + String(url.split(separator: "#")[0])
            }
            self.avatar = "https:" + (doc.xpath("//table/tr/td[1]/a/img[@class='avatar']").first?["src"] ?? "")
            self.nodeName = doc.xpath("//table/tr/td[3]/span[2]/a").first?.content
            self.nodeURL = doc.xpath("//table/tr/td[3]/span[2]/a").first?["href"]
            self.username = doc.xpath("//table/tr/td[3]/span[2]/strong[1]").first?.content
            self.commentUser = doc.xpath("//table/tr/td[3]/span[2]/strong[2]").first?.content
            self.commentCount = doc.xpath("//table/tr/td[4]/a").first?.content

            if let timeString = doc.xpath(timeXpath).first?.content {
                self.commentTime = timeString.split(separator: "•")[1].trimmingCharacters(in: .whitespaces)
            }

        } catch let error as NSError {
            print(error.userInfo)
            return nil
        }
    }

    class func getPostList(tab: String? = nil, node: Node? = nil, page: Int = 1, completion: @escaping ([Post]) -> Void) {
        var url = baseURL
        var params = [String: String]()
        var xpath = "//div[@class='cell item']"

        if let node = node {
            xpath = "//div[@id='TopicsNode']/div"
            url += node.url ?? ""
            params["p"] = "\(page)"
        } else if tab == "recent" {
            url += "/recent"
            params["p"] = "\(page)"
        } else {
            params["tab"] = tab
        }

        let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36"

        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: ["User-Agent": userAgent]).responseString { response in
            var posts = [Post]()
            guard let html = response.result.value else {
                return
            }
            do {
                let doc = try HTML(html: html, encoding: .utf8)
                for element in doc.xpath(xpath) {
                    if let post = Post(html: element.toHTML!, isFromNode: node != nil) {
                        posts.append(post)
                    }
                }
            } catch let error as NSError {
                print(error.userInfo)
            }
            completion(posts)
        }
    }
}

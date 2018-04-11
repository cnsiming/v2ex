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

    init() {
        self.url = nil
        self.avatar = nil
        self.title = nil
        self.nodeName = nil
        self.nodeURL = nil
        self.username = nil
        self.commentTime = nil
        self.commentUser = nil
        self.commentCount = nil
    }

    init?(forPage pageType: PageType, html: String) {
        do {
            let doc = try HTML(html: html, encoding: .utf8)

            // 如果检测到首页状态未登录，清除登录状态
            if User.shared.isLogin, let button = doc.xpath("//*[@id='Top']/div/div/table/tr/td[3]/a[3]").first?["href"], button == "/signin" {
                User.shared = User()
                User.shared.saveUserInfo()
            }

            switch pageType {
            case .home(_), .collection(_):
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
                self.commentTime = doc.xpath("//table/tr/td[3]/span[2]/text()[3]").first?.content?.split(separator: "•")[1].trimmingCharacters(in: .whitespaces)
            case .node(_):
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
                self.commentTime = doc.xpath("//table/tr/td[3]/span[2]/text()").first?.content?.split(separator: "•")[1].trimmingCharacters(in: .whitespaces)
            case .my(_):
                if let title = doc.xpath("//table/tr/td[1]/span[1]/a").first?.content {
                    self.title = title
                } else {
                    return nil
                }
                if let url = doc.xpath("//table/tr/td[1]/span[1]/a").first?["href"] {
                    self.url = baseURL + String(url.split(separator: "#")[0])
                }
                self.avatar = User.shared.avatar
                self.nodeName = doc.xpath("//table/tr/td[1]/span[2]/a").first?.content
                self.nodeURL = doc.xpath("//table/tr/td[1]/span[2]/a").first?["href"]
                self.username = doc.xpath("//table/tr/td[1]/span[2]/strong[1]/a").first?.content
                self.commentUser = doc.xpath("//table/tr/td[1]/span[2]/strong[2]/a").first?.content
                self.commentCount = doc.xpath("//table/tr/td[2]/a").first?.content
                self.commentTime = doc.xpath("//table/tr/td[1]/span[2]/text()[3]").first?.content?.split(separator: "•")[1].trimmingCharacters(in: .whitespaces)
            }

        } catch let error as NSError {
            print(error.userInfo)
            return nil
        }
    }

    class func getPostList(from pageType: PageType, pageNum: Int = 1, completion: @escaping ([Post]) -> Void) {
        var url = baseURL
        var params = ["p": "\(pageNum)"]
        var xpath = "//div[@class='cell item']"

        switch pageType {
        case .home(let tab):
            if tab.rawValue == "all" && pageNum > 1 {
                url += "/recent"
            } else {
                params["tab"] = tab.rawValue
                params.removeValue(forKey: "p")
            }
        case .node(let node):
            xpath = "//div[@id='TopicsNode']/div"
            url += node.url ?? ""
        case .collection(let collection):
            url += collection.rawValue
        case .my(.posts(let myPostsUrl)):
            url += myPostsUrl
        default:
            print(pageType)
        }

        let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36"

        Alamofire.request(url, parameters: params, headers: ["User-Agent": userAgent]).validate().responseString { response in
            var posts = [Post]()
            if let html = response.result.value {
                do {
                    let doc = try HTML(html: html, encoding: .utf8)
                    for element in doc.xpath(xpath) {
                        if let post = Post(forPage: pageType, html: element.toHTML!) {
                            posts.append(post)
                        }
                    }
                } catch let error as NSError {
                    print(error.userInfo)
                }
            }
            completion(posts)
        }
    }
}

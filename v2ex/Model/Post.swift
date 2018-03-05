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

let baseURL = "https://www.v2ex.com/"

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
    private var dataTask: URLSessionDataTask? = nil

    init(html: String) {
        do {
            let doc = try HTML(html: html, encoding: .utf8)

            self.url = doc.xpath("//table/tr/td[3]/span[1]/a").first?["href"]
            self.avatar = doc.xpath("//table/tr/td[1]/a/img[@class='avatar']").first?["src"]
            self.title = doc.xpath("//table/tr/td[3]/span[1]/a").first?.content
            self.nodeName = doc.xpath("//table/tr/td[3]/span[2]/a").first?.content
            self.nodeURL = doc.xpath("//table/tr/td[3]/span[2]/a").first?["href"]
            self.username = doc.xpath("//table/tr/td[3]/span[2]/strong[1]").first?.content
            self.commentUser = doc.xpath("//table/tr/td[3]/span[2]/strong[2]").first?.content
            self.commentCount = doc.xpath("//table/tr/td[4]/a").first?.content

            if let timeString = doc.xpath("//table/tr/td[3]/span[2]/text()[3]").first?.content {
                self.commentTime = timeString.split(separator: "•")[1].trimmingCharacters(in: .whitespaces)
            }


        } catch let error as NSError {
            print(error.userInfo)
        }
    }

    class func getPostList(of tab: String) -> [Post] {
        var posts = [Post]()
        if let url = URL(string: baseURL + "?tab=" + tab) {
            do {
                let html = try Data(contentsOf: url)
                let doc = try HTML(html: html, encoding: .utf8)
                for post in doc.xpath("//div[@class='cell item']") {
                    posts.append(Post(html: post.toHTML!))
                }
            } catch let error as NSError {
                print(error.userInfo)
            }
        }

        return posts
    }
}

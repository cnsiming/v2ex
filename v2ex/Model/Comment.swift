//
//  Comment.swift
//  v2ex
//
//  Created by wjb on 2018/3/8.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import Kanna

class Comment {
    var avatar: String?
    var username: String?
    var time: String?
    var content: String?

    init?(by element: String) {
        do {
            let doc = try HTML(html: element, encoding: .utf8)

            // 如果获取不到恢复内容，就跳过
            if let content = doc.xpath("//*[@class='reply_content']").first?.content {
                self.content = content
            } else {
                return nil
            }
            self.avatar = "https:" + (doc.xpath("//img").first?["src"] ?? "")
            self.username = doc.xpath("//td[3]/strong").first?.content
            self.time = doc.xpath("//td[3]/span").first?.content
        } catch let error as NSError {
            print(error.userInfo)
            return nil
        }
    }
}

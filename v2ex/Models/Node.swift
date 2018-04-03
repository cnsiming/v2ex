//
//  Node.swift
//  v2ex
//
//  Created by wjb on 2018/3/2.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import Alamofire
import Kanna

struct NodeType: Codable {
    var type: String?
    var nodes: [Node]?

    static func loadDefaultNodes() -> [NodeType] {
        var results = [NodeType]()
        do {
            let decoder = JSONDecoder()
            let jsonURL = Bundle.main.url(forResource: "nodes", withExtension: "json")!
            let jsonData = try Data(contentsOf: jsonURL)
            results = try decoder.decode([NodeType].self, from: jsonData)
        } catch let error as NSError {
            print(error.userInfo)
        }
        return results
    }
}

struct Node: Codable {
    var name: String?
    var url: String?
    var logo: String?
    var comments: String?

    init?(html: String) {
        do {
            let doc = try HTML(html: html, encoding: .utf8)
            self.name = doc.xpath("//a/div/text()[2]").first?.content
            self.url = doc.xpath("//a").first?["href"]
            self.logo = "https:" + (doc.xpath("//div/img").first?["src"] ?? "")
            self.comments = doc.xpath("//div/span").first?.content?.trimmingCharacters(in: .whitespaces)
        } catch let error as NSError {
            print(error.userInfo)
        }
    }

    static func getCollection(completion: @escaping ([Node]) -> Void) {
        let url = baseURL + PageType.Collection.favoriteNodes.rawValue
        let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36"

        Alamofire.request(url, headers: ["User-Agent": userAgent]).validate().responseString { response in
            var nodes = [Node]()

            if let html = response.result.value {
                do {
                    let doc = try HTML(html: html, encoding: .utf8)
                    for element in doc.xpath("//a[@class='grid_item']") {
                        if let node = Node(html: element.toHTML!) {
                            nodes.append(node)
                        }
                    }
                } catch let error as NSError {
                    print(error.userInfo)
                }
            }

            completion(nodes)
        }
    }
}



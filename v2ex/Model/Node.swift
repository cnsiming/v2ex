//
//  Node.swift
//  v2ex
//
//  Created by wjb on 2018/3/2.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import Foundation

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
}



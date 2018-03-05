//
//  API.swift
//  v2ex
//
//  Created by wjb on 2018/3/5.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import Foundation

class API {
    let baseURL = "https://www.v2ex.com/api/"
    let hot = "https://www.v2ex.com/api/topics/hot.json"
    let python = "https://www.v2ex.com/api/nodes/show.json?name=python"

    func fetch()  -> Data? {
        guard let url = URL(string: hot) else {
            return nil
        }
        do {
            return try Data(contentsOf: url)
        } catch {
            return nil
        }
    }

    func parse(data : Data) -> [Post] {
        do {
            let decoder = JSONDecoder()
            let results =  try decoder.decode([Post].self, from: data)
            return results
        } catch let error as NSError{
            print(error.userInfo)
            return []
        }
    }
}

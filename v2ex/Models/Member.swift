//
//  Member.swift
//  v2ex
//
//  Created by wjb on 2018/3/2.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

import Foundation

struct Member: Codable {
    var id: Int?
    var username = ""
    var tagline = ""
    var avatarMini = ""  // "avatar_mini" : "//cdn.v2ex.com/navatar/94f6/d7e0/300_mini.png?m=1519960851"
    var avatarNormal = ""
    var avatarLarge = ""

    enum CodingKeys: String, CodingKey{
        case id, username, tagline
        case avatarMini = "avatar_mini"
        case avatarNormal = "avatar_normal"
        case avatarLarge = "avatar_large"
    }
}

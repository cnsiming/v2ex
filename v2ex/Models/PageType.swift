//
//  PageType.swift
//  v2ex
//
//  Created by wjb on 2018/3/27.
//  Copyright © 2018年 com.wujiangbin.v2ex. All rights reserved.
//

enum PageType {
    case home(Tab)
    case node(Node)
    case collection(Collection)
    case my(My)

    enum Tab: String {
        case tech       // 技术
        case creative   // 创意
        case play       // 好玩
        case apple      // Apple
        case jobs       // 酷工作
        case deals      // 交易
        case city       // 城市
        case qna        // 问与答
        case hot        // 最热
        case all        // 全部
        case r2         // R2
        case nodes      // 节点
        case members    // 关注
    }

    enum Collection: String {
        case favoriteNodes = "/my/nodes"
        case favoritePosts = "/my/topics"
        case following = "/my/following"
    }

    enum My {
        case posts(String)
        case comments(String)
    }
}



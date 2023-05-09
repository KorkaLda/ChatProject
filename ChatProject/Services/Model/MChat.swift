//
//  MChat.swift
//  ChatProject
//
//  Created by Vladimir on 16.02.2023.
//

import UIKit

struct MChat: Hashable, Decodable {
    var friendUsername: String
    var friendAvatarImageString: String
    var lastMessageContent: String
    var friendId: String
    
    var representation: [String: Any] {
        var rep = ["friendUsername": friendUsername]
        rep["friendAvatarStringURL"] = friendAvatarImageString
        rep["friendId"] = friendId
        rep["lastMessage"] = lastMessageContent
        return rep
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    static func == (lhs: MChat, rhs: MChat) -> Bool {
        return lhs.friendId == rhs.friendId
    }
}

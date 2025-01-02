//
//  PathType.swift
//  Sachosaeng
//
//  Created by LJh on 7/26/24.
//

import Foundation

enum PathType: Hashable {
    case sign
    case occupation
    case favorite
    case signSuccess
    case home
    case myPage
    case info
    case quit
    case daily
    case usersFavorite
    case inquiry 
    case openSource
    case userData
    case service
    case FAQ
    case voteDetail(Int)
    case voteRegistration
    case voteHistory
    case registeredVotes(Int)
}

enum TabType: Hashable {
    case home
    case bookMark
    case edit
    case myPage
}

struct SachosaengPath: Hashable {
    let spath: PathType
    let switchTab: TabType
}

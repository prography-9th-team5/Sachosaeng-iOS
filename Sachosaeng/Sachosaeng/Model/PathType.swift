//
//  PathType.swift
//  Sachosaeng
//
//  Created by LJh on 7/26/24.
//

import Foundation

public enum PathType {
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
}

struct SachosaengPath: Hashable {
    let spath: PathType
    let switchTab: TabItem
}

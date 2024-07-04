//
//  User.swift
//  Sachosaeng
//
//  Created by LJh on 7/5/24.
//

import Foundation

struct ResponseUser {
    let code: Int
    let message: String
    let data: User
}

struct User {
    let userId: Int
    let nickname: String
    var userType: String
    let userCategory: [Int]?
}


var tempUser = User(userId: 0, nickname: "temp", userType: "학생", userCategory: nil )

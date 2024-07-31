//
//  UserStore.swift
//  Sachosaeng
//
//  Created by LJh on 7/5/24.
//

import Foundation

final class UserStore: ObservableObject {
    static let shared = UserStore()

    @Published var newUser = User(userId: 0, nickname: "temp", userType: "학생", userCategory: nil )
    
    // private 초기화 메서드 (외부에서 직접 인스턴스 생성 방지)
    private init() {}
}

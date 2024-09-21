//
//  TabBarStore.swift
//  Sachosaeng
//
//  Created by LJh on 9/20/24.
//

import Foundation

class TabBarStore: ObservableObject {
    @Published var switchTab: TabItem = .home
    @Published var isOpacity: Bool = false
}

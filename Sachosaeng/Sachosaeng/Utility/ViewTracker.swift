//
//  ViewTracker.swift
//  Sachosaeng
//
//  Created by LJh on 9/21/24.
//

import Foundation

enum TrackingType {
    case sign
    case home
    case category
    case success
    case voteDetail
    case information
    case quit
    case mypage
    case bookmark
}

enum TrackingTabType {
    case home
    case bookmark
}

class ViewTracker: ObservableObject {
    static let shared = ViewTracker()
    @Published var currentView: TrackingType = .sign
    @Published var currentTap: TrackingTabType = .home
    
    func updateCurrentView(to newView: TrackingType) {
        currentView = newView
    }
    
    func convertViewName(_ view: TrackingType) -> String {
        switch view {
            case .sign:
                return "Sign"
            case .home:
                return "Home"
            case .category:
                return "Category"
            case .success:
                return "Success"
            case .voteDetail:
                return "Vote Detail"
            case .information:
                return "Information"
            case .quit:
                return "Quit"
            case .mypage:
                return "My Page"
            case .bookmark:
                return "Bookmark"
        }
    }
}

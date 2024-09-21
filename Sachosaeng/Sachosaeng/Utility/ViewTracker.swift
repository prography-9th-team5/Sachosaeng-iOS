//
//  ViewTracker.swift
//  Sachosaeng
//
//  Created by LJh on 9/21/24.
//

import Foundation

enum TrackingType {
    case home
    case sign
    case category
    case success
    case vote
    case mypage
    case bookmark
}

class ViewTracker: ObservableObject {
    static let shared = ViewTracker()
    @Published var currentView: TrackingType = .sign
        
    func updateCurrentView(to newView: TrackingType) {
        jhPrint(newView)
        currentView = newView
    }
}

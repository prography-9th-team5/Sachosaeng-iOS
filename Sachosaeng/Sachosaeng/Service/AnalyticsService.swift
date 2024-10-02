//
//  AnalyticsService.swift
//  Sachosaeng
//
//  Created by LJh on 10/2/24.
//

import Foundation
import FirebaseAnalytics

final class AnalyticsService {
    static var shared = AnalyticsService()
    
    private init() {}
    
    func trackView(_ viewName: String) {
        Analytics.logEvent(viewName, parameters: nil)
    }
    
    func trackAction(_ actionName: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(actionName, parameters: parameters)
    }
}

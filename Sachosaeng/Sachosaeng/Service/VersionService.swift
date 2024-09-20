//
//  VersionStore.swift
//  Sachosaeng
//
//  Created by LJh on 9/14/24.
//

import Foundation
enum UpdateType {
    case force, select, latest
}
final class VersionService: ObservableObject {
    private var networkService = NetworkService.shared
    static let shared = VersionService()
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

    func fetchAllVersion() {
        let path = "/api/v1/versions/ios"
        
        networkService.performRequest(method: "GET", path: path, body: nil, token: nil) { (result: Result<Response<ReponseVersion>, NetworkError>) in
            switch result {
            case .success(let version):
                jhPrint("\(version.data)")
            case .failure(let error):
                jhPrint(error)
            }
        }
    }
   
    func updateVersion() {
        let path = "/api/v1/versions/ios"
        let body = ["version": version]
        
        networkService.performRequest(method: "POST", path: path, body: body, token: nil) { (result: Result<Response<EmptyData>, NetworkError>) in
            
            switch result {
            case .success(_):
                jhPrint("버전 등록 성공")
            case .failure(let error):
                jhPrint(error)
            }
        }
    }
    
    func verifyVersion() {
        let path = "/api/v1/versions/ios/\(version)"
        
        networkService.performRequest(method: "GET", path: path, body: nil, token: nil) { (result: Result<Response<Version>, NetworkError>) in
            
            switch result {
            case .success(let version):
                    jhPrint("버전 등록 성공\(version.data)")
            case .failure(let error):
                jhPrint(error)
            }
        }
    }
}

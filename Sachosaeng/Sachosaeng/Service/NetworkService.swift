//
//  NertworkServicee.swift
//  Sachosaeng
//
//  Created by LJh on 8/14/24.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case userExists
    case valueAlreadyExists(String)
}

final class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func performRequest<T: Decodable>(method: String, path: String, body: [String: Any]?, token: String?, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        guard let url = URL(string: "https://sachosaeng.store" + path) else {
            completion(.failure(.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
        }
        
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(.failure(.requestFailed(error)))
                return
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 || httpResponse.statusCode == 409 || httpResponse.statusCode == 400 else {
                completion(.failure(.invalidResponse))
                return
            }
//            jhPrint("path: \(path), method: \(method)", isWarning: true)
            guard httpResponse.statusCode != 400 else {
                completion(.failure(.valueAlreadyExists("code: 400입니다. 무언가 있기에 뜨는 코드라고 합니다요")))
                return
            }

            guard httpResponse.statusCode != 409 else {
                completion(.failure(.userExists))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch let decodingError {
                if let jsonString = String(data: data, encoding: .utf8) {
                    jhPrint("""
                            path: \(path), 
                            code: \(httpResponse.statusCode),
                            Decoding Error: \(decodingError.localizedDescription),
                            Decoding message: \(jsonString)
                            """ , isWarning: true)
                }
                completion(.failure(.decodingFailed(decodingError)))
            }
        }
        task.resume()
    }
}

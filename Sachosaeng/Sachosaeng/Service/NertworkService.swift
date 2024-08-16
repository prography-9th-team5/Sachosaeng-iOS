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
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 || httpResponse.statusCode == 400 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard httpResponse.statusCode != 400 else {
                completion(.failure(.userExists))
                return
            }
            
            jhPrint("path: \(path), code: \(httpResponse.statusCode)")
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch let decodingError {
                if let jsonString = String(data: data, encoding: .utf8) {
                    jhPrint("Decoding error: \(decodingError.localizedDescription), Decoding message: \(jsonString)" , isWarning: true)
                }
                completion(.failure(.decodingFailed(decodingError)))
            }
        }
        task.resume()
    }
}

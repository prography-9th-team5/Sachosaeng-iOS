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
    
    func performRequest<T: Decodable>(method: String, path: String, body: [String: Any]?, token: String?, headers: [String: String]? = nil,  completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let sachosaengUrl = Bundle.main.object(forInfoDictionaryKey: "sachosaengUrl") as? String else {
            completion(.failure(.badURL))
            return
        }
        guard let url = URL(string: "https://" + sachosaengUrl + path) else {
            completion(.failure(.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
        }
        
        if let headers = headers {
            for (key , value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
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
                jhPrint(path, isWarning: true)
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                jhPrint(path, isWarning: true)
                completion(.failure(.invalidResponse))
                return
            }
            jhPrint("httpResponse.statusCode: \(httpResponse.statusCode)")
            if httpResponse.statusCode == 400 {
                completion(.failure(.valueAlreadyExists("code: 400입니다. 무언가 있기에 뜨는 코드라고 합니다요")))
                return
            } else if httpResponse.statusCode == 409 {
                completion(.failure(.userExists))
                return
            } else if httpResponse.statusCode != 200 {
                completion(.failure(.invalidResponse))
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
                jhPrint("httpResponse.statusCode : \(httpResponse.statusCode)", isWarning: true)
                completion(.failure(.decodingFailed(decodingError)))
            }
        }
        task.resume()
    }
}

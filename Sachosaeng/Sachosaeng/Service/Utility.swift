//
//  Utility.swift
//  Sachosaeng
//
//  Created by LJh on 7/24/24.
//

import Foundation

public func fetchData<T: Codable>(from urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
            return
        }
        do {
            let decodedResponse = try JSONDecoder().decode(Response<T>.self, from: data)
            completion(.success(decodedResponse.data))
        } catch {
            completion(.failure(error))
        }
    }
    task.resume()
}

public func jhPrint(_ object: Any, isWarning: Bool = false, filename: String = #file, _ line: Int = #line, _ funcname: String = #function) {
    if isWarning {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        print("""
          🚨 Log!! : \(dateFormatter.string(from: Date()))
          🚨 file: \(filename)
          🚨 line: \(line) , 🚨 func: \(funcname)
          """)
        print(object)
    } else {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        print("""
          ⭐️ Log!! : \(dateFormatter.string(from: Date()))
          ⭐️ file: \(filename)
          ⭐️ line: \(line) , ⭐️ func: \(funcname)
          """)
        print(object)
    }
}

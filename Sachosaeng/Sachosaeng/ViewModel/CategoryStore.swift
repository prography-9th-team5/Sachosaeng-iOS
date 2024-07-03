//
//  CategoryStore.swift
//  Sachosaeng
//
//  Created by LJh on 7/3/24.
//

import Foundation

class CategoryStore: ObservableObject {
    @Published var categories = [Category]()
    @Published var categoryCount: Int = 0

    func fetchCategories() async {
        guard let url = URL(string: "https://sachosaeng.store/categories") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching categories: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
                self.categories = decodedResponse.data
                self.categoryCount = self.categories.count
//                print(self.categoryCount)
                
            } catch {
                print("Error decoding response: \(error)")
            }
        }
        
        task.resume()
    }
}

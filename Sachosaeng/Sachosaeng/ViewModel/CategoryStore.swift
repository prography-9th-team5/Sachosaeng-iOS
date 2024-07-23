//
//  CategoryStore.swift
//  Sachosaeng
//
//  Created by LJh on 7/3/24.
//

import Foundation

@MainActor
class CategoryStore: ObservableObject {
    @Published var categories = [Category]()
    
    func fetchCategories() async {
        categories.removeAll()
        guard let url = URL(string: "https://sachosaeng.store/api/v1/categories") else { return }

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
                let decodedResponse = try JSONDecoder().decode(ResponseCategory.self, from: data)
                DispatchQueue.main.async {
                    self.categories = decodedResponse.data
//                    self.addAllCategory()
                }
            } catch {
                print("Error decoding response: \(error)")
            }
        }
        
        task.resume()
    }
//    
    func addAllCategory() {
        categories.insert(Category(categoryId: 999, name: "ALL", iconUrl: "https://sachosaeng.store/icon/all-2x.png", backgroundColor: "", textColor: ""), at: 0)
    }
}

//
//  CategoryStore.swift
//  Sachosaeng
//
//  Created by LJh on 7/3/24.
//

import Foundation

class CategoryStore: ObservableObject {
    @Published var categories = [Category]()
    
    func fetchCategories() async {
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
                }
            } catch {
                print("Error decoding response: \(error)")
            }
        }
        
        task.resume()
    }
    
    func addAllCategory() {
        categories.insert(Category(categoryId: 999, name: "ALL", iconUrl: "https://www.figma.com/design/rSeqGRWceTWtAsv5wHVlfj/%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9D%BC%ED%94%BC9%EA%B8%B0_5%ED%8C%80?node-id=1195-17074&t=kfaLMLN27SioWqGX-4", backgroundColor: "", textColor: ""), at: 0)
    }
}

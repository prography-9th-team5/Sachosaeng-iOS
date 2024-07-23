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
    @Published var allCatagory = [Category]()
    
    func fetchCategories() async {
        categories.removeAll()
        allCatagory.removeAll()
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
                    self.allCatagory = decodedResponse.data
                    self.fetchAllCategory()
                }
            } catch {
                print("Error decoding response: \(error)")
            }
        }
        task.resume()
    }
    
    func fetchAllCategory() {
        guard let url = URL(string: "https://sachosaeng.store/api/v1/categories/icon-data/all") else { return }
        
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
                let decodedResponse = try JSONDecoder().decode(ResponseAllCategory.self, from: data)
                DispatchQueue.main.async {
                    self.allCatagory.insert(Category(categoryId: 999, name: "전체 보기", iconUrl: decodedResponse.data.iconUrl, backgroundColor: decodedResponse.data.backgroundColor, textColor: ""), at: 0)
//                    print("🎉 성공: ResponseAllCategory() \(decodedResponse.data)")
//                    print("allCatagory: \(self.allCatagory)")
                }
            } catch {
                print("🚨에러: ResponseAllCategory() 리스폰스 디코딩 실패 🚨: \(error)")
            }
        }
        task.resume()
    }
   
}

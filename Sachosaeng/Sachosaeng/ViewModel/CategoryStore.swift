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
        fetchData(from: "https://sachosaeng.store/api/v1/categories") { (result: Result<[Category], Error>) in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.categories = result
                    self.allCatagory = result
                    self.fetchAllCategory()
                }
            case .failure(let error):
                print("🚨 에러: fetchCategories() 실패 🚨: \(error)")
            }
        }
    }
    
    func fetchAllCategory() {
        fetchData(from: "https://sachosaeng.store/api/v1/categories/icon-data/all") { (result: Result<AllCategory, Error>) in
            switch result {
            case .success(let allCate):
                DispatchQueue.main.async {
                    self.allCatagory.insert(Category(categoryId: 99999, name: "전체 보기", iconUrl: allCate.iconUrl, backgroundColor: allCate.backgroundColor, textColor: ""), at: 0)
                }
            case .failure(let error):
                print("🚨 에러: fetchAllCategory() 실패 🚨: \(error)")
            }
        }
    }
}

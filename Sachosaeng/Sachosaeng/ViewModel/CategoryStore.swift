//
//  CategoryStore.swift
//  Sachosaeng
//
//  Created by LJh on 7/3/24.
//

import Foundation

@MainActor
class CategoryStore: ObservableObject {
    private let networkService = NetworkService.shared
    @Published var categories = [Category]()
    @Published var allCatagory = [Category]()
    
    func fetchCategories() {
        categories.removeAll()
        allCatagory.removeAll()
        let path = "/api/v1/categories"
        
        networkService.performRequest(method: "GET", path: path, body: nil, token: nil) { (result: Result<Response<ResponseCategoriesData>, NetworkError>) in
            switch result {
                case .success(let result):
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        DispatchQueue.main.async {
                            self.categories = result.data.categories
                            self.allCatagory = result.data.categories
                            self.fetchAllCategory()
                        }
                    }
                case .failure(let error):
                    jhPrint(error, isWarning: true)
            }
        }
    }
    
    func fetchAllCategory() {
        let path = "/api/v1/categories/icon-data/all"
        
        networkService.performRequest(method: "GET", path: path, body: nil, token: nil) { (result: Result<Response<AllCategory>, NetworkError>) in
            switch result {
                case .success(let result):
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        allCatagory.insert(Category(categoryId: 00000, name: "전체 보기", iconUrl: result.data.iconUrl, backgroundColor: result.data.backgroundColor, textColor: ""), at: 0)
                        
                    }
                case .failure(let error):
                    jhPrint(error, isWarning: true)
            }
        }
    }
}

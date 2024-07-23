//
//  VoteStore.swift
//  Sachosaeng
//
//  Created by LJh on 7/23/24.
//

import Foundation

final class VoteStore: ObservableObject {
    @Published var hotVotes: HotVote = HotVote(category: dummyCategory, votes: [dummyVote])
    @Published var dailyVote: Vote = dummyVote
    
    func fetchHotVotes() async {
        guard let url = URL(string: "https://sachosaeng.store/api/v1/votes/hot") else { return }

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
                let decodedResponse = try JSONDecoder().decode(ResponseHotVote.self, from: data)
                DispatchQueue.main.async {
                    let hotVote: HotVote = decodedResponse.data[0]
                    self.hotVotes = dummyHotvote
                    print("🎉 성공: fetchHotVotes() \(decodedResponse.data)")
                    print("🎉 hotVotes: \(self.hotVotes)")
                }
            } catch {
                print("🚨에러: fetchHotVotes() 리스폰스 디코딩 실패 🚨: \(error)")
            }
        }
        task.resume()
    }
    
    func fetchDaily() async {
        guard let url = URL(string: "https://sachosaeng.store/api/v1/votes/daily") else { return }
        
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
                let decodedResponse = try JSONDecoder().decode(ResponseDailyVote.self, from: data)
                DispatchQueue.main.async {
                    self.dailyVote = decodedResponse.data
//                    print("🎉 성공: fetchDaily() \(decodedResponse.data)")
//                    print("🎉 dailyVote: \(self.dailyVote)")
                }
            } catch {
                print("🚨에러: fetchDaily() 리스폰스 디코딩 실패 🚨: \(error)")
            }
        }
        task.resume()
    }
}

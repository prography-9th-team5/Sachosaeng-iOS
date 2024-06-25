//
//  Vote.swift
//  Sachosaeng
//
//  Created by LJh on 6/26/24.
//

import SwiftUI

struct Vote: Identifiable {
    var id: UUID = UUID()
    var title: String
    var voted: Int
    var image: Image
}

let tempVote: [Vote] = [
    Vote(title: "상사와의 전화에서 마무리 말을 어떻게 해야할까요?", voted: 10, image: Image("Progressbaricon")),
    Vote(title: "첫 출근 날 팀원들에게 어떻게 인사해야할까요?1231414224215", voted: 1000, image: Image("Progressbaricon")),
    Vote(title: "신입사원 첫 회식 추천해 주세요.", voted: 500, image: Image("Progressbaricon")),
    ]


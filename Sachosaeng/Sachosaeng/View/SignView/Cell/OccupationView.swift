//
//  OccupationView.swift
//  Sachosaeng
//
//  Created by LJh on 6/19/24.
//

import SwiftUI

struct OccupationView: View {
    
    @Binding var isSelected: Bool
    let occupationNumber: Int
    let occupationImage: [Image] = [
        Image("학생"),
        Image("취업준비생"),
        Image("1~3년차 직장인"),
        Image("기타")
    ]
    let occupationDescription: [String] = ["학생", "취업준비생", "1~3년차 직장인", "기타"]
    
    var body: some View {
        VStack {
            Image(isSelected ? "\(occupationDescription[occupationNumber])" : "\(occupationDescription[occupationNumber])_off")
                .resizable()
                .scaledToFit()
            Text(occupationDescription[occupationNumber])
                .foregroundStyle(CustomColor.GrayScaleColor.black)
                .font(.createFont(weight: .medium, size: 16))
        }
    }
}

#Preview {
    OccupationView(isSelected: .constant(false), occupationNumber: 1)
}
// TODO: 이미지 받으면 변경예정 

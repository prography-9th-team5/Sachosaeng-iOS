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
    let occupationImage: [Image] = [Image("mungmungE"), Image("mungmungE"), Image("mungmungE"), Image("mungmungE")]
    let occupationDescription: [String] = ["학생", "취업준비생", "1~3년차 직장인", "기타"]
    
    var body: some View {
        VStack {
            TempImageView(isBorder: false, width: 161, height: 144)
                .border(Color.black, width: isSelected ? 1 : 0)
            Text(occupationDescription[occupationNumber])
                .foregroundStyle(CustomColor.GrayScaleColor.black)
                .font(isSelected ? .createFont(weight: .extraBold, size: 16) : .createFont(weight: .medium, size: 16))
        }
    }
}

#Preview {
    OccupationView(isSelected: .constant(true), occupationNumber: 1)
}
// TODO: 이미지 받으면 변경예정 

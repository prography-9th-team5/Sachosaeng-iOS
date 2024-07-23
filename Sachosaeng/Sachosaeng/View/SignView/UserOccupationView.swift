//
//  UserOccupationView.swift
//  Sachosaeng
//
//  Created by LJh on 6/19/24.
//

import SwiftUI

struct UserOccupationView: View {
    
    // MARK: - Properties
    @Binding var isSign: Bool

    @State private var selectedOccupations: [Bool] = Array(repeating: false, count: 4)
    @State var isSelected: Bool = false
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                CustomSliderProgressBarView(progress: 1, isImageHide: false)
                    .padding(.trailing, 12)
                CustomSliderProgressBarView(progress: 0, isImageHide: true)
            }
            .padding(.bottom, 32)
            .padding(.top, 10.9)
            .padding(.horizontal, 20)
            
            HStack(spacing: 0) {
                CommonTitle(top: "어떤 사회초년생에",
                            topFont: .bold,
                            middle: "해당되나요?",
                            middleFont: .black,
                            footer: "*선택한 유형에 맞는 정보를 제공해 드려요",
                            footerFont: .light, isSuccessView: false)
            }
            .frame(height: 100)
            
            ForEach(0..<2) { row in
                HStack(spacing: 10) {
                    ForEach(0..<2) { column in
                        let occupationDescription: [String] = ["학생", "취업준비생", "1~3년차 직장인", "기타"]
                        let occupationNumber = row * 2 + column
                        
                        Button {
                            selectedOccupations[occupationNumber] = true
                            isSelected = true
                            UserStore.shared.newUser.userType = occupationDescription[occupationNumber]
                            for index in 0..<selectedOccupations.count {
                                if index != occupationNumber {
                                    selectedOccupations[index] = false
                                }
                            }
                        } label: {
                            OccupationView(isSelected: $selectedOccupations[occupationNumber], occupationNumber: occupationNumber)
                        }
                    }
                }
            }
            .padding(.top, 44)
            .padding(.horizontal, 20)
            .navigationTitle("1 유저타입 선택")
            .navigationBarTitleDisplayMode(.inline)
            Spacer()
            
            NavigationLink {
                UserFavoriteCategoryView(isSign: $isSign)
                    .customBackbutton()
            } label: {
                Text("다음")
                    .font(.createFont(weight: .medium, size: 16))
                    .modifier(DesignForNext(isSelected: $isSelected))
            }
            .disabled(!isSelected)
        } //: Vstack
    }
}

#Preview {
    NavigationStack {
        UserOccupationView(isSign: .constant(false))
    }
}

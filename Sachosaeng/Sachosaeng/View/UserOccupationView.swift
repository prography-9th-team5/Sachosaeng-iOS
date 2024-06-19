//
//  UserOccupationView.swift
//  Sachosaeng
//
//  Created by LJh on 6/19/24.
//

import SwiftUI

struct UserOccupationView: View {
    
    // MARK: - Properties
    @State private var selectedOccupations: [Bool] = Array(repeating: false, count: 4)
    @State var isSelected: Bool = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                Group {
                    HStack {
                        Text("1/2")
                            .font(.createFont(weight: .light, size: 16))
                            .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                        Spacer()
                        NavigationLink {
                            // TODO: 유저정보 저장
                            UserFavoriteCategoryView()
                        } label: {
                            Text("SKIP")
                                .font(.createFont(weight: .light, size: 16))
                                .foregroundStyle(CustomColor.GrayScaleColor.gs5)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .padding(.top, 30)
                    CommonTitle(top: "당신은 어떤",
                                topFont: .medium,
                                middle: "사회초년생인가요?",
                                middleFont: .black,
                                footer: "*하나만 선택해 주세요",
                                footerFont: .light)
                } //: Group
                
                Spacer()
                
                ForEach(0..<2) { row in
                    HStack(spacing: 10) {
                        ForEach(0..<2) { column in
                            let occupationNumber = row * 2 + column
                            Button(action: {
                                selectedOccupations[occupationNumber] = true
                                isSelected = true
                                // TODO: 유저가 고른 직종 유저 데이터에 넣기
                                for index in 0..<selectedOccupations.count {
                                    if index != occupationNumber {
                                        selectedOccupations[index] = false
                                    }
                                }
                            }, label: {
                                OccupationView(isSelected: $selectedOccupations[occupationNumber], occupationNumber: occupationNumber)
                            })
                        }
                    }
                    .padding()
                }
                
                Spacer()
                NavigationLink {
                    // TODO: 유저정보 저장 
                    UserFavoriteCategoryView()
                } label: {
                    Text("다음")
                        .font(.createFont(weight: .medium, size: 16))
                }
                .frame(width: PhoneSpace.screenWidth * 0.9, height: 47)
                .foregroundStyle(CustomColor.GrayScaleColor.white)
                .background(isSelected ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs4)
                .cornerRadius(4)
                .navigationBarBackButtonHidden(true)
            } //: Vstack
        }
    }
}

#Preview {
    UserOccupationView()
}

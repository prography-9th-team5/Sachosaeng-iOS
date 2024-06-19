//
//  UserFavoriteCategoryView.swift
//  Sachosaeng
//
//  Created by LJh on 6/19/24.
//

import SwiftUI

struct UserFavoriteCategoryView: View {
    var body: some View {
        VStack {
            Group {
                HStack {
                    Text("2/2")
                        .font(.createFont(weight: .light, size: 16))
                        .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Text("SKIP")
                            .font(.createFont(weight: .light, size: 16))
                            .foregroundStyle(CustomColor.GrayScaleColor.gs5)
                    })
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                .padding(.top, 50)
                CommonTitle(top: "선호하는 카테고리를",
                            topFont: .medium,
                            middle: "모두 선택해 주세요",
                            middleFont: .black,
                            footer: "*복수 선택이 가능해요",
                            footerFont: .light)
            }
            
            ScrollView {
                Grid {
                    
                }
            }
        }
    }
}

#Preview {
    UserFavoriteCategoryView()
}

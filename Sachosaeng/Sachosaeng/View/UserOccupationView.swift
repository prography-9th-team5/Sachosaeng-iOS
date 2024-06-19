//
//  UserOccupationView.swift
//  Sachosaeng
//
//  Created by LJh on 6/19/24.
//

import SwiftUI

struct UserOccupationView: View {
    var body: some View {
        VStack {
            Group {
                HStack {
                    Text("1/2")
                        .font(.createFont(weight: .light, size: 16))
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Text("SKIP")
                            .font(.createFont(weight: .light, size: 16))

                    })
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                .padding(.top, 50)
                
                HStack {
                    Text("사회생활 고민을 풀어봐요!")
                        .font(.createFont(weight: .medium, size: 26))
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                
                HStack {
                    Text("사회초년생 집단지성 투표 플랫폼")
                        .font(.createFont(weight: .light, size: 16))
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                
            } //: Group
        }
    }
}

#Preview {
    UserOccupationView()
}

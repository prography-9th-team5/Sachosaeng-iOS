//
//  MainView.swift
//  Sachosaeng
//
//  Created by LJh on 6/26/24.
//

import SwiftUI

enum TabItem {
    case home
    case setting
}

struct MainView: View {
    @State var switchTab: TabItem = .home
    var body: some View {
        VStack {
            // 상단 콘텐츠 영역
            switch switchTab {
                case .home:
                    HomeView()
                case .setting:
                    SignView()
            }
            
            Spacer() // 상단 콘텐츠를 위로 밀어 올리기 위한 Spacer
            
            // 하단 탭바 영역
            HStack(spacing: 0) {
                Spacer()
                Button {
                    switchTab = .home
                } label: {
                    Image("HomeTab")
                }
                
                Spacer()

                Button {
                    switchTab = .setting
                } label: {
                    Image("HomeTab")
                        .foregroundStyle(CustomColor.GrayScaleColor.gs4)
                }
                Spacer()

            }
            .frame(height: 76)
            .background(CustomColor.GrayScaleColor.gs4)
            .cornerRadius(15, corners: [.topLeft, .topRight])
            
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
    }
}

#Preview {
    MainView()
}

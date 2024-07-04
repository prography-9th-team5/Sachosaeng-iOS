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
                    UserOccupationView()
            }
            
            Spacer()
            
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
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    MainView()
}

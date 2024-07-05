//
//  MainView.swift
//  Sachosaeng
//
//  Created by LJh on 6/26/24.
//

import SwiftUI

enum TabItem {
    case home
    case vote
}

struct MainView: View {
    @Binding var path: NavigationPath
    @State var switchTab: TabItem = .home
    
    var body: some View {
        VStack {
            // 상단 콘텐츠 영역
            switch switchTab {
                case .home:
                    HomeView(path: $path)
                case .vote:
                    VoteView()
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
                    switchTab = .vote
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
    MainView(path: .constant(NavigationPath()))
}

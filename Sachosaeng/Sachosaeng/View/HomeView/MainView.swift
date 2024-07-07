//
//  MainView.swift
//  Sachosaeng
//
//  Created by LJh on 6/26/24.
//

import SwiftUI

enum TabItem {
    case home
    case bookMark
}

struct MainView: View {
    @Binding var path: NavigationPath
    @State var switchTab: TabItem = .home
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 콘텐츠 영역
            switch switchTab {
                case .home:
                    HomeView(path: $path)
                case .bookMark:
                    EmptyView()
            }
            
            ZStack {
                CustomColor.GrayScaleColor.gs4
                HStack(spacing: 0) {
                    Spacer()
                    Button {
                        switchTab = .home
                    } label: {
                        Image(switchTab == .home ? "HomeTab" : "HomeTab_off")
                    }
                    
                    Spacer()

                    Button {
                        switchTab = .bookMark
                    } label: {
                        Image(switchTab == .bookMark ? "bookmark" : "bookmark_off")
                            .foregroundStyle(CustomColor.GrayScaleColor.gs4)
                    }
                    Spacer()
                }
            }
            .frame(height: 76)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .background(CustomColor.GrayScaleColor.gs2)
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    MainView(path: .constant(NavigationPath()))
}

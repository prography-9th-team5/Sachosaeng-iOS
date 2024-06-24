//
//  HomeView.swift
//  Sachosaeng
//
//  Created by LJh on 6/24/24.
//

import SwiftUI

struct HomeView: View {
    @State var categoryName: String = "전체"
    private var categoryButtonName: String = "카테고리 변경"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Text(categoryName)
                        .font(.createFont(weight: .medium, size: 26))
                    Button {
                        
                    } label: {
                        ZStack {
                            Text(categoryButtonName)
                                .font(.createFont(weight: .medium, size: 14))
                        }
                    }
                    Spacer()
                    
                }
                ScrollView {
                    
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

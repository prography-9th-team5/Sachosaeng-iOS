//
//  CategoryModal.swift
//  Sachosaeng
//
//  Created by LJh on 6/26/24.
//

import SwiftUI

struct CategoryModal: View {
    @StateObject var categoryStore: CategoryStore
    @State private var gridLayout: [GridItem] = [GridItem(.flexible())]
    @State private var gridColumn: Double = 3.0
    @State private var tapCount = 0
    @State private var isMyCategory = true
    @State private var isEdit = false
    private func gridSwitch() {
        gridLayout = Array(repeating: .init(.flexible()), count: Int(gridColumn))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 32.24)
                .foregroundStyle(CustomColor.GrayScaleColor.gs4)
                .frame(width: 72, height: 6)
                .padding(.bottom, 28)
                .padding(.top, 20)
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Button {
                            withAnimation {
                                isMyCategory = true
                                isEdit = false
                            }
                        } label: {
                            Text("내 카테고리")
                                .font(.createFont(weight: isMyCategory ? .bold : .medium, size: 18))
                                .foregroundStyle(isMyCategory ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs5)
                        }
                        .padding(.trailing, 24)
                        
                        Button {
                            withAnimation {
                                isMyCategory = false
                                isEdit = false
                            }
                        } label: {
                            Text("전체 카테고리")
                                .font(.createFont(weight: isMyCategory ? .medium : .bold, size: 18))
                                .foregroundStyle(isMyCategory ? CustomColor.GrayScaleColor.gs5 : CustomColor.GrayScaleColor.black)
                        }
                            Spacer()
                        if isMyCategory  {
                            Button {
                                isEdit.toggle()
                            } label: {
                                Text("편집")
                                    .font(.createFont(weight: .medium, size: 14))
                                    .foregroundStyle(CustomColor.GrayScaleColor.gs5)
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.leading, 1)
                
                HStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 32.24)
                        .foregroundStyle(.clear)
                        .frame(width: isMyCategory ? 0 : 104.5, height: 2)
                    RoundedRectangle(cornerRadius: 32.24)
                        .foregroundStyle(CustomColor.GrayScaleColor.black)
                        .frame(width: isMyCategory ? 86 : 106, height: 2)
                    Spacer()
                }
                .padding(.top, 14)
            }
            .padding(EdgeInsets(top: 0, leading: 18, bottom: 0, trailing: 20))
            
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
                        if isEdit {
                            ForEach(categoryStore.categories) { category in
                                Button {
                                    // TODO: 데이터 받고 재자업
                                } label: {
                                    CategoryCellView(tapCount: $tapCount, category: category, categoryNumber: category.id)
                                        .padding(.bottom, 32)
                                }
                            }
                        } else {
                            // TODO: - 여기서는 사용자가 지정한 카테고리를 나타나게끔
                        }
                    }
                    .onAppear {
                        gridSwitch()
                    }
                }
                .padding(.top, 28)
                if isEdit {
                    Button {
                        
                    } label: {
                        Text("완료")
                            .font(.createFont(weight: .medium, size: 16))
                            .modifier(DesignForNextWithTapCount(tapCount: $tapCount))
                    }
                }
            }
        }
    }
}

#Preview {
    CategoryModal(categoryStore: CategoryStore())
}

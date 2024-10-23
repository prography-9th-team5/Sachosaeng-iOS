//
//  VoteRegistrationView.swift
//  Sachosaeng
//
//  Created by LJh on 10/20/24.
//

import SwiftUI

struct VoteRegistrationView: View {
    @State private var isMultipleSelection: Bool = false
    @State private var titleText: String = ""
    @State private var list1Text: String = ""
    @State private var list2Text: String = ""
    @State private var list3Text: String = ""
    @State private var list4Text: String = ""
    @State private var choiceTextArray: [String] = ["", "", "", ""]
    var body: some View {
        ZStack {
            CustomColor.GrayScaleColor.gs2.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("*사초생이 검토 후 투표에 등록할게요!")
                        .font(.createFont(weight: .medium, size: 12))
                        .foregroundStyle(CustomColor.GrayScaleColor.gs5)
                    Spacer()
                }
                .padding(.bottom, 25)
                
                VStack(spacing: 0) {
                    titleView(titleString: "투표 제목")
                        .padding(.bottom, 12)
                    
                    TextField("투표 제목을 작성해 주세요", text: $titleText.max(100), axis: .vertical)
                        .font(.createFont(weight: .medium, size: 12))
                        .padding(16)
                        .background(CustomColor.GrayScaleColor.white)
                        .cornerRadius(8, corners: .allCorners)
                        .lineLimit(2...2)
                }
                .padding(.bottom, 36)

                VStack(spacing: 0) {
                    titleView(titleString: "선택지")
                        .padding(.bottom, 12)
                    ForEach(choiceTextArray.indices, id: \.self) { text in
                        TextField("선택지 \(text)", text: $choiceTextArray[text].max(100), axis: .vertical)
                            .font(.createFont(weight: .medium, size: 12))
                            .padding(16)
                            .background(CustomColor.GrayScaleColor.white)
                            .cornerRadius(8, corners: .allCorners)
                            .lineLimit(1...2)
                            .padding(.bottom, 8)
                    }
                }
                
                titleView(titleString: "카테고리")
                    .padding(.bottom, 12)
            }
            .padding()
        }
    }
}

extension VoteRegistrationView {
    @ViewBuilder
    private func titleView(titleString: String) -> some View {
        HStack(spacing: 0) {
            Text(titleString)
                .font(.createFont(weight: .semiBold, size: 15))
                .foregroundStyle(CustomColor.GrayScaleColor.black)
            Spacer()
        }
        
    }
}

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(limit))
            }
        }
        return self
    }
}

//
//  VoteRegistrationView.swift
//  Sachosaeng
//
//  Created by LJh on 10/20/24.
//

import SwiftUI

struct VoteRegistrationView: View {
    @ObservedObject var categoryStore: CategoryStore
    @ObservedObject var voteStore: VoteStore
    @Binding var path: NavigationPath
    @State private var isMultipleSelection: Bool = false
    @State private var titleText: String = ""
    @State private var choiceTextArray: [String] = ["", "", "", ""]
    @State private var chosenCategory: Int?
    @State private var toast: Toast? = nil
    @State private var isRegistration: Bool = false
    var body: some View {
        ZStack {
            CustomColor.GrayScaleColor.gs2.ignoresSafeArea()
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    HStack(spacing: 0) {
                        Text("*등록한 투표 삭제는 1:1 문의에서 요청할 수 있어요!")
                            .font(.createFont(weight: .medium, size: 12))
                            .foregroundStyle(CustomColor.GrayScaleColor.gs6)
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
                        HStack(spacing: 0) {
                            titleView(titleString: "선택지")
                                .padding(.bottom, 12)
                            Button {
                                let emptyStringCount = choiceTextArray.filter { $0 == "" }.count
                                if emptyStringCount < 3 {
                                    isMultipleSelection.toggle()
                                }
                            } label: {
                                HStack(spacing: 0) {
                                    Image(isMultipleSelection ? "checkCircle_true" : "checkCircle_false")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 16, height: 16)
                                        .padding(.trailing, 6)
                                    Text("복수 선택 가능")
                                        .font(.createFont(weight: .medium, size: 12))
                                        .foregroundStyle(CustomColor.GrayScaleColor.black)
                                }
                            }
                        }
                        
                        ForEach(choiceTextArray.indices, id: \.self) { text in
                            TextField("선택지 \(text + 1)", text: $choiceTextArray[text].max(100), axis: .vertical)
                                .font(.createFont(weight: .medium, size: 12))
                                .padding(16)
                                .background(CustomColor.GrayScaleColor.white)
                                .cornerRadius(8, corners: .allCorners)
                                .lineLimit(1...2)
                                .padding(.bottom, 8)
                        }
                    }
                    .padding(.bottom, 36)
                    
                    LazyVStack(spacing: 0) {
                        titleView(titleString: "카테고리")
                            .padding(.bottom, 12)
                        ForEach(categoryStore.categories.chunked(into: 3), id: \.self) { rowCategories in
                            HStack(spacing: 0) {
                                ForEach(rowCategories) { category in
                                    configCategoryButtons(category: category)
                                        .padding(.trailing, 8)
                                }
                                Spacer()
                            }
                            .padding(.bottom, 8)
                        }
                    }
                    .padding(.bottom, 27)
                    
                    Spacer()
                    
                }
                Button {
                    if isNext() {
                        choiceTextArray.removeAll { $0 == "" }
                        if !isRegistration {
                            isRegistration = true
                            if let chosenCategory {
                                voteStore.registrationVote(title: titleText, isMulti: isMultipleSelection, voteOptions: choiceTextArray, categoryIds: chosenCategory) { isSuccess in
                                    if isSuccess {
                                        toast = Toast(type: .quit, message: "등록한 투표는 관리자 검토 후 업로드돼요")
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            path.append(PathType.home)
                                        }
                                    } else {
                                        toast = Toast(type: .quit, message: "등록실패")
                                    }
                                }
                            } else {
                                toast = Toast(type: .quit, message: "등록실패")
                            }
                        }
                    } else {
                        toast = Toast(type: .quit, message: "모든 정보를 기입해 주세요.")
                    }
                } label: {
                    Text("등록")
                        .font(.createFont(weight: .medium, size: 16))
                        .frame(width: PhoneSpace.screenWidth - 40, height: 47)
                        .foregroundStyle(CustomColor.GrayScaleColor.white)
                        .background(isNext() ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs4)
                        .cornerRadius(4)
                }
            }
            .padding(.top)
            .padding(.horizontal)
        }
        .showToastView(toast: $toast)
        .navigationTitle("투표 등록")
        .navigationBarTitleTextColor(CustomColor.GrayScaleColor.gs6, .medium, size: 18)
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension VoteRegistrationView {
    private func isNext() -> Bool {
        var textCount: Int = 0
        for text in choiceTextArray {
            if text != "" {
                textCount += 1
            }
        }
        if titleText != "" && textCount > 1 && chosenCategory != nil {
            return true
        } else {
            return false
        }
    }

    @ViewBuilder
    private func titleView(titleString: String) -> some View {
        HStack(spacing: 0) {
            Text(titleString)
                .font(.createFont(weight: .semiBold, size: 15))
                .foregroundStyle(CustomColor.GrayScaleColor.black)
            Spacer()
        }
    }
    
    @ViewBuilder
    private func configCategoryButtons(category: Category) -> some View {
        Button {
            if chosenCategory != category.id {
                chosenCategory = category.id
            } else {
                chosenCategory = nil
            }
        } label: {
            HStack(spacing: 0) {
                AsyncImage(url: URL(string: category.iconUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18)
                } placeholder: {
                    ProgressView()
                }
                .padding(.trailing, 8)
                .grayscale(chosenCategory == category.id ? 0 : 1)
                .opacity(chosenCategory == category.id ? 1 : 0.25)
                
                Text(category.name)
                    .font(.createFont(weight: .medium, size: 12))
                    .foregroundStyle(chosenCategory == category.id
                                     ? Color(hex: category.textColor)
                                     : CustomColor.GrayScaleColor.gs4)
            }
            .padding(.horizontal, 12)
            .frame(height: 36)
            .background(chosenCategory == category.id
                        ? Color(hex: category.backgroundColor)
                        : CustomColor.GrayScaleColor.white)
            .cornerRadius(4, corners: .allCorners)
        }
    }
}

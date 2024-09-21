//
//  QuitView.swift
//  Sachosaeng
//
//  Created by LJh on 7/25/24.
//
import UIKit
import SwiftUI

enum QuitType: String, CaseIterable, Identifiable {
    case service = "서비스 불만족"
    case content = "콘텐츠 부족"
    case use = "더 이상 사용하지 않음"
    case etc = "기타 (직접 입력)"
    var id: String { self.rawValue }
}

struct QuitView: View {
    @Binding var isSign: Bool
    @Binding var path: NavigationPath
    @State private var toast: Toast? = nil
    @State private var isSelected: Bool = false
    @State private var isTapped: QuitType?
    @State private var isTappedEtc: Bool = false    
    @State private var text: String = ""
    @FocusState private var keyboardVisible: Bool
    private let quitTypeArray: [QuitType] = QuitType.allCases

    
    var body: some View {
        VStack(spacing: 0) {
            CommonTitle(top: "랜덤이름님", topFont: .bold, middle: "떠난다니 아쉬워요...", middleFont: .bold, footer: "사초생 탈퇴 사유를 알려주세요.", footerFont: .medium, isSuccessView: false)
                .padding(.bottom, 45.5)
            
            ScrollViewReader { reader in
                ScrollView {
                    Spacer()
                    ForEach(quitTypeArray, id: \.self) { type in
                        Button {
                            isSelected = true
                            isTapped = type
                        } label: {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isTapped == type ? Color.black : Color.clear, lineWidth: 1)
                                .frame(maxWidth: .infinity, minHeight: 60)
                                .foregroundStyle(CustomColor.GrayScaleColor.white)
                                .overlay(alignment: .leading) {
                                    HStack(spacing: 0) {
                                        Image(isTapped == type ? "check_on" : "check_off")
                                            .padding(.leading, 16)
                                            .padding(.trailing, 8)
                                        Text(type.rawValue)
                                            .font(.createFont(weight: .medium, size: 18))
                                            .foregroundStyle(CustomColor.GrayScaleColor.black)
                                    }
                                }
                                .padding(.horizontal, 20)
                        }
                    }
                    
                    if isTapped == .etc {
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: UIScreen.main.bounds.width - 42, height: 105)
                                    .padding(8)
                                    .foregroundStyle(CustomColor.GrayScaleColor.gs2)
                                CustomTextEditor(text: $text)
                                    .frame(width: UIScreen.main.bounds.width - 80, height: 75)
                                    .background(Color.clear)
                                    .focused($keyboardVisible)
                                    .onTapGesture {
                                        isTappedEtc = true
                                    }
                                    .overlay(alignment: .topLeading) {
                                        if text.isEmpty && !isTappedEtc {
                                            HStack(spacing: 0) {
                                                Text("사유를 작성해 주세요")
                                                    .foregroundColor(CustomColor.GrayScaleColor.gs5)
                                                    .onTapGesture {
                                                        isTappedEtc = true
                                                }
                                                Spacer()
                                            }
                                        }
                                    }
                            }
                            .padding(.bottom, 12)
                            .padding(.top, 5)
                            .frame(width: UIScreen.main.bounds.width - 40)
                            Spacer()
                        }
                        .id("bottom")
                    }
                } // : ScrollView
                .frame(width: PhoneSpace.screenWidth )
                .onChange(of: keyboardVisible) { newValue in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation {
                            reader.scrollTo("bottom", anchor: .top)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            Spacer()
            Button {
                if keyboardVisible {
                    hideKeyboard()
                } else {
                    toast = Toast(type: .quit, message: "탈퇴가 완료되었어요")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isSign = true
                        AuthService().withdrawUserAccount()
                        path = .init()
                    }
                }
            } label: {
                if keyboardVisible {
                    Text("완료")
                        .font(.createFont(weight: .medium, size: 16))
                        .foregroundStyle(CustomColor.GrayScaleColor.white)
                        .frame(width: PhoneSpace.screenWidth, height: 47)
                        .background(isSelected ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs4)
                } else {
                    Text("저장")
                        .font(.createFont(weight: .medium, size: 16))
                        .modifier(DesignForNext(isSelected: $isSelected))
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .showToastView(toast: $toast)
    }
}

#Preview {
    NavigationStack {
        QuitView(isSign: .constant(false), path: .constant(NavigationPath()))
            .customBackbutton()
    }
}

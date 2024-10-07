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
    @EnvironmentObject var signStore: SignStore
    @EnvironmentObject var tabBarStore: TabBarStore
    @EnvironmentObject var userInfoStore: UserInfoStore
    @Binding var isSign: Bool
    @Binding var path: NavigationPath
    @State private var toast: Toast? = nil
    @State private var isSelected: Bool = false
    @State private var tappedQuitType: QuitType?
    @State private var isTappedEtc: Bool = false    
    @State private var etcText: String = ""
    @FocusState private var keyboardVisible: Bool
    private let quitTypeArray: [QuitType] = QuitType.allCases
    @State private var isSuccessperform: Bool = true

    var body: some View {
        VStack(spacing: 0) {
            CommonTitle(top: userInfoStore.currentUserState.nickname + "님", topFont: .bold, middle: "떠난다니 아쉬워요...", middleFont: .bold, footer: "사초생 탈퇴 사유를 알려주세요.", footerFont: .medium, isSuccessView: false)
            
            ScrollViewReader { reader in
                ScrollView {
                    Spacer().frame(height: 20)
                    ForEach(quitTypeArray, id: \.self) { type in
                        Button {
                            isSelected = true
                            tappedQuitType = type
                        } label: {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(tappedQuitType == type ? CustomColor.GrayScaleColor.black : Color.clear, lineWidth: 1.5)
                                .frame(maxWidth: .infinity, minHeight: 60)
                                .foregroundStyle(CustomColor.GrayScaleColor.white)
                                .overlay(alignment: .leading) {
                                    HStack(spacing: 0) {
                                        Image(tappedQuitType == type ? "check_on" : "check_off")
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
                    
                    if tappedQuitType == .etc {
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: UIScreen.main.bounds.width - 42, height: 105)
                                    .padding(8)
                                    .foregroundStyle(CustomColor.GrayScaleColor.gs2)
                                CustomTextEditor(text: $etcText)
                                    .frame(width: UIScreen.main.bounds.width - 80, height: 75)
                                    .background(Color.clear)
                                    .focused($keyboardVisible)
                                    .onTapGesture {
                                        isTappedEtc = true
                                    }
                                    .overlay(alignment: .topLeading) {
                                        if etcText.isEmpty && !isTappedEtc {
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
                .padding(.top, 20)
            }
            Spacer()
            Button {
                if keyboardVisible {
                    hideKeyboard()
                } else {
                    if isSuccessperform  {
                        isSuccessperform = false
                        toast = Toast(type: .quit, message: "탈퇴가 완료되었어요")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            tabBarStore.reset()
                            isSign = true
                            switch tappedQuitType {
                                case .content, .service, .use:
                                    signStore.withdrawUserAccount(tappedQuitType?.rawValue ?? "sad")
                                case .etc:
                                    signStore.withdrawUserAccount(etcText)
                                case .none:
                                    toast = Toast(type: .quit, message: "탈퇴 실패 다시 시도해주세요.")
                            }
                            path = .init()
                        }
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
            .disabled(!isSelected)
        }
        .onAppear(perform: {
            ViewTracker.shared.updateCurrentView(to: .quit)
        })
        .onTapGesture {
            hideKeyboard()
        }
        .showToastView(toast: $toast)
    }
}

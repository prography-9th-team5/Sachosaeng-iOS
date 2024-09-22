//
//  EditMyInfoView.swift
//  Sachosaeng
//
//  Created by LJh on 7/24/24.
//

import SwiftUI

enum UserType: String, CaseIterable, Identifiable {
    case STUDENT = "학생"
    case JOB_SEEKER = "취업준비생"
    case NEW_EMPLOYEE = "1~3년차 직장인"
    case OTHER = "기타"
    var id: String { self.rawValue }
}

struct EditMyInfoView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userInfoStore: UserInfoStore
    @EnvironmentObject var userService: UserService
    @Binding var isSign: Bool
    @Binding var path: NavigationPath
    @State private var selectedType: UserType?
    @State private var isSelected: Bool = false
    @State private var isSelectedQuitButton: Bool = false
    @State private var toast: Toast? = nil
    @State private var userTypeArray: [UserType] = UserType.allCases
    @State private var textField: String = ""
    @State private var controlDisableModifier: Bool = true
    private let imageFrame = 127.54
    private let rows = [GridItem(.fixed(48)), GridItem(.fixed(48))]
    private let columns = [GridItem(), GridItem()]
    
    var body: some View {
        ZStack {
            CustomColor.GrayScaleColor.gs2.edgesIgnoringSafeArea(.all)
            VStack {
                ScrollView {
                    VStack(spacing: 0) {
                        Image("온보딩_\(selectedType?.rawValue ?? userInfoStore.currentUserState.userType)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageFrame, height: imageFrame)
                            .padding(.top, 10)
                            .padding(.bottom, 16)
                        Text(selectedType?.rawValue ?? userInfoStore.currentUserState.userType)
                            .font(.createFont(weight: .bold, size: 16))
                    }
                    .padding(.bottom, 56)
                    
                    VStack(spacing: 0) {
                        HStack {
                            Text("닉네임")
                                .font(.createFont(weight: .bold, size: 18))
                                .padding(.bottom, 14)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: PhoneSpace.screenWidth - 40,height: 48)
                            .foregroundStyle(CustomColor.GrayScaleColor.white)
                            .padding(.bottom, 34)
                            .overlay(alignment: .leading) {
                                if textField.isEmpty {
                                    HStack {
                                        Text(userInfoStore.currentUserState.nickname)
                                            .font(.createFont(weight: .medium, size: 15))
                                            .padding(16)
                                        .padding(.bottom, 34)
                                        Spacer()
                                    }
                                }
                                TextField("", text: $textField)
                                    .font(.createFont(weight: .medium, size: 15))
                                    .padding(16)
                                    .padding(.bottom, 34)
                            }
                        
                        HStack {
                            Text("사초생 유형 변경")
                                .font(.createFont(weight: .bold, size: 18))
                                .padding(.bottom, 14)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        
                        LazyVGrid(columns: columns) {
                            ForEach(userTypeArray, id: \.self) { type in
                                Button {
                                    selectedType = type
                                    isSelected = true
                                } label: {
                                    RoundedRectangle(cornerRadius: 8)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 48)
                                        .foregroundStyle(CustomColor.GrayScaleColor.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(selectedType == type ? CustomColor.GrayScaleColor.black : Color.clear, lineWidth: 1)
                                        )
                                    
                                }
                                .overlay(alignment: .leading) {
                                    Text(type.rawValue)
                                        .font(.createFont(weight: .medium, size: 15))
                                        .padding(16)
                                }
                                .overlay(alignment: .trailing) {
                                    Image(selectedType == type ? "check_on" : "check_off")
                                        .padding(16)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 35)
                        
                        Button {
                            isSelectedQuitButton = true
                        } label: {
                            HStack {
                                Text("탈퇴하기")
                                    .font(.createFont(weight: .medium, size: 16))
                                    .foregroundStyle(CustomColor.GrayScaleColor.gs5)
                                    .underline()
                                Spacer()
                            }
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                    }
                }
                .showToastView(toast: $toast)
                .navigationTitle("내 정보 수정")
                .navigationBarTitleDisplayMode(.inline)
                
                Button {
                    if isSelected {
                        userInfoStore.currentUserState.userType = selectedType!.rawValue
                        userService.updateUserType(userInfoStore.convertUserTypeForEnglish(selectedType?.rawValue ?? "학생"))
                    }
                    if !textField.isEmpty {
                        userInfoStore.currentUserState.nickname = textField
                        userService.updateUserNickname(UserInfoStore.shared.currentUserState.nickname)
                    }
                    toast = Toast(type: .saved, message: "저장되었습니다")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        dismiss()
                    }
                } label: {
                    Text("저장")
                        .font(.createFont(weight: .medium, size: 16))
                        .frame(width: PhoneSpace.screenWidth * 0.9, height: 47)
                        .foregroundStyle(CustomColor.GrayScaleColor.white)
                        .background(isSelected || !textField.isEmpty ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs4)
                        .cornerRadius(4)
                }
                .disabled(isSelected || !textField.isEmpty ? false : true)
            }
        }
        .showPopupView(isPresented: $isSelectedQuitButton, message: .quit, primaryAction: {
            path.append(PathType.quit)
        }, secondaryAction: { })
        .onTapGesture {
            self.hideKeyboard()
        }
    }
}

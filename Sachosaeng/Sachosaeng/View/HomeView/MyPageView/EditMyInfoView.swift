//
//  EditMyInfoView.swift
//  Sachosaeng
//
//  Created by LJh on 7/24/24.
//

import SwiftUI

enum UserType: String, CaseIterable, Identifiable {
    case student = "학생"
    case jobSeeker = "취업준비생"
    case workers = "1~3년차 직장인"
    case etc = "기타"
    var id: String { self.rawValue }
}

struct EditMyInfoView: View {
    @Binding var isSign: Bool
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss
    @State private var selectedType: UserType?
    @State private var isSelected: Bool = false
    @State private var isSelectedQuitButton: Bool = false
    @State private var toast: Toast? = nil
    @State private var userTypeArray: [UserType] = UserType.allCases
    private let imageFrame = 127.54
    private let rows = [ GridItem(.fixed(48)), GridItem(.fixed(48))]
    private let columns = [ GridItem(), GridItem()]
    
    var body: some View {
        ZStack {
            CustomColor.GrayScaleColor.gs2.edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Image("온보딩_\(selectedType?.rawValue ?? "학생")")
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageFrame, height: imageFrame)
                        .padding(.top, 10)
                        .padding(.bottom, 26)
                    Text(selectedType?.rawValue ?? "유저의 정보를 받으면 바뀔 예정일거에요")
                        .font(.createFont(weight: .bold, size: 16))
                    
                }
                .padding(.bottom, 48)
                
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
                        Text("유저 이름이 들어가야 하겠죠 ?")
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
                
                Button {
                    toast = Toast(type: .saved, message: "저장되었습니다")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        dismiss()
                    }
                } label: {
                    Text("완료")
                        .font(.createFont(weight: .medium, size: 16))
                        .modifier(DesignForNext(isSelected: $isSelected))
                }
                
            }
            .showPopupView(isPresented: $isSelectedQuitButton, message: .quit, primaryAction: {
                path.append(PathType.quit)
            }, secondaryAction: {
                
            })
            .showToastView(toast: $toast)
            .navigationTitle("내 정보 수정")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        EditMyInfoView(isSign: .constant(false), path: .constant(NavigationPath()))
        
    }
}

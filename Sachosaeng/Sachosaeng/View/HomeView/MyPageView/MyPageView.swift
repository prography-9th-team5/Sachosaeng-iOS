//
//  MyPageView.swift
//  Sachosaeng
//
//  Created by LJh on 7/5/24.
//

import SwiftUI

enum myPageOption: String , CaseIterable {
    case changeName = "닉네임 변경"
    case inquiry = "1:1 문의"
}

enum settingOption: String, CaseIterable {
    case version = "버전 안내"
    case openSource = "오픈소스 라이브러리"
    case userData = "개인정보 처리 방침"
    case service = "서비스 이용 약관"
    case FAQ = "FAQ"
}

struct MyPageView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            CustomColor.GrayScaleColor.gs2.edgesIgnoringSafeArea(.all)
            ScrollView {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                        .frame(width: PhoneSpace.screenWidth - 40, height: 80)
                        .overlay(alignment: .topTrailing) {
                            NavigationLink {
                                EditMyInfoView()
                                    .customBackbutton()
                            } label: {
                                Image("settingMyInfoIcon")
                                    .padding(16)
                            }

                        }
                    HStack(spacing: 0) {
                        Image("온보딩_1~3년차 직장인")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                        VStack(alignment: .leading, spacing: 0) {
                            // TODO: - 여기부분 디자인 적인 부분 수정 + 유저값에 따른 변화를 줘야함
                            Text("글자 글가즐가")
                                .font(.createFont(weight: .medium, size: 12))
                                .foregroundStyle(CustomColor.GrayScaleColor.white)
                            Text("닉네임자리")
                                .font(.createFont(weight: .bold, size: 18))
                                .foregroundStyle(CustomColor.GrayScaleColor.white)
                        }
                        
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 28)
                
                ForEach(myPageOption.allCases, id: \.self) { name in
                    Button {
                        path.append(name.rawValue)
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: PhoneSpace.screenWidth - 40, height: 60)
                            .foregroundStyle(CustomColor.GrayScaleColor.white)
                            .overlay {
                                HStack(spacing: 0) {
                                    Text(name.rawValue)
                                        .padding(.horizontal, 10)
                                        .font(.createFont(weight: .medium, size: 15))
                                        .foregroundStyle(CustomColor.GrayScaleColor.black)
                                    Spacer()
                                    Image("arrowRight")
                                        .padding(.horizontal, 16)
                                }
                            }
                    }
                    .padding(.bottom, 1)
                }
                
                HStack {
                    Text("설정")
                        .font(.createFont(weight: .semiBold, size: 18))
                    Spacer()
                }
                .padding(EdgeInsets(top: 32, leading: 20, bottom: 14, trailing: 20))
                
                ForEach(settingOption.allCases, id: \.self) { name in
                    Button {
                        path.append(name.rawValue)
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: PhoneSpace.screenWidth - 40,height: 60)
                            .foregroundStyle(CustomColor.GrayScaleColor.white)
                            .overlay {
                                HStack(spacing: 0) {
                                    Text(name.rawValue)
                                        .padding(.horizontal, 10)
                                        .font(.createFont(weight: .medium, size: 15))
                                        .foregroundStyle(CustomColor.GrayScaleColor.black)
                                    Spacer()
                                    if name.rawValue == "버전 안내" {
                                        HStack(spacing: 0) {
                                            Text("최신 버전")
                                                .padding(.horizontal, 8)
                                                .font(.createFont(weight: .medium, size: 15))
                                                .foregroundStyle(CustomColor.GrayScaleColor.gs5)
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .frame(width: 63, height: 27)
                                                    .foregroundStyle(CustomColor.GrayScaleColor.gs2)
                                                    .padding(.trailing, 16)
                                                HStack {
                                                    Text("v0.0.1")
                                                        .font(.createFont(weight: .medium, size: 15))
                                                        .foregroundStyle(CustomColor.GrayScaleColor.black)
                                                }
                                                .padding(.trailing, 16)
                                            }
                                        }
                                    } else {
                                        Image("arrowRight")
                                            .padding(.horizontal, 16)
                                    }
                                }
                            }
                    }
                    .padding(.bottom, 1)
                }
                
                Button {
                    
                } label: {
                    HStack {
                        Text("로그아웃")
                            .font(.createFont(weight: .medium, size: 16))
                            .foregroundStyle(CustomColor.GrayScaleColor.gs5)
                            .underline()
                        Spacer()
                    }
                }
                .padding(20)
            }            
            .scrollIndicators(.hidden)
            .navigationTitle("마이페이지")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    NavigationStack {
        MyPageView(path: .constant(NavigationPath()))
    }
}

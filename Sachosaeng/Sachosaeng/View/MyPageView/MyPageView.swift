//
//  MyPageView.swift
//  Sachosaeng
//
//  Created by LJh on 7/5/24.
//

import SwiftUI

enum myPageOption: String , CaseIterable {
    case usersFavorite = "관심사 설정"
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
    @EnvironmentObject var userStore: UserInfoStore
    @EnvironmentObject var userInfoStore: UserInfoStore
    @EnvironmentObject var signStore: SignStore
    @Binding var isSign: Bool
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
                            Button {
                                path.append(PathType.info)
                            } label: {
                                Image("settingMyInfoIcon")
                                    .padding(16)
                            }
                            
                        }
                    HStack(spacing: 0) {
                        Image("온보딩_\(userStore.currentUserState.userType)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                        VStack(alignment: .leading, spacing: 0) {
                            Text("\(userStore.currentUserState.userType)")
                                .font(.createFont(weight: .medium, size: 12))
                                .foregroundStyle(CustomColor.GrayScaleColor.white)
                            Text("\(userStore.currentUserState.nickname)")
                                .font(.createFont(weight: .bold, size: 18))
                                .foregroundStyle(CustomColor.GrayScaleColor.white)
                        }
                        
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 28)
                
                ForEach(myPageOption.allCases, id: \.self) { myPageOptionPath in
                    Button {
                        switch myPageOptionPath {
                        case .usersFavorite:
                            path.append(PathType.usersFavorite)
                        case .inquiry:
                            path.append(PathType.inquiry)
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: PhoneSpace.screenWidth - 40, height: 60)
                            .foregroundStyle(CustomColor.GrayScaleColor.white)
                            .overlay {
                                HStack(spacing: 0) {
                                    Text(myPageOptionPath.rawValue)
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
                
                ForEach(settingOption.allCases, id: \.self) { settingOptionPath in
                    Button {
                        switch settingOptionPath {
                        case .openSource:
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        case .userData:
                            path.append(PathType.userData)
                        case .service:
                            path.append(PathType.service)
                        case .FAQ:
                            path.append(PathType.FAQ)
                        case .version:
                            break
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: PhoneSpace.screenWidth - 40,height: 60)
                            .foregroundStyle(CustomColor.GrayScaleColor.white)
                            .overlay {
                                HStack(spacing: 0) {
                                    Text(settingOptionPath.rawValue)
                                        .padding(.horizontal, 10)
                                        .font(.createFont(weight: .medium, size: 15))
                                        .foregroundStyle(CustomColor.GrayScaleColor.black)
                                    Spacer()
                                    if settingOptionPath.rawValue == "버전 안내" {
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
                                                    Text("\(VersionService.shared.version)")
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
                    signStore.logOut()
                    path = .init()
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
        .onAppear {
            ViewTracker.shared.updateCurrentView(to: .mypage)
        }
    }
}

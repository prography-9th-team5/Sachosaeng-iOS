//
//  MyPageView.swift
//  Sachosaeng
//
//  Created by LJh on 7/5/24.
//

import SwiftUI
import SafariServices
import MessageUI

enum myPageOption: String , CaseIterable {
    case usersFavorite = "관심사 설정"
    case inquiry = "1:1 문의"
    case history = "투표 등록 히스토리"
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
    @State private var showWK1 = false
    @State private var showWK2 = false
    @State private var showWK3 = false
    @State private var choosenSettingOption: settingOption = .version
    @State private var showingMailView = false
    @State private var webUrl: URL?
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State var isPopUpView: Bool = false
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
                            showingMailView.toggle()
                        case .history:
                            path.append(PathType.voteHistory)
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
                                showWK1 = true
                            case .service:
                                showWK2 = true
                            case .FAQ:
                                showWK3 = true
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
                    isPopUpView = true
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
            .sheet(isPresented: $showWK1) {
                SafariView(url: URL(string: "https://foregoing-hoof-160.notion.site/d3ea3926640746ce9156fc23251fda7e")!)
            }
            .sheet(isPresented: $showWK2) {
                SafariView(url: URL(string: "https://foregoing-hoof-160.notion.site/7621154595c445068d833c931a4cefc5?pvs=74")!)
            }
            .sheet(isPresented: $showWK3) {
                SafariView(url: URL(string: "https://foregoing-hoof-160.notion.site/FAQ-107a24e5b9e88045bd68c6bc5507fd4f")!)
            }
            .sheet(isPresented: $showingMailView) {
                MailView(result: self.$mailResult, recipients: ["sachosaeng@gmail.com"], subject: "1:1 문의", messageBody: """
                                    문의할 사항을 입력해주세요. 
                                    
                                    
                                    
                                    Device Model : \(userInfoStore.getDeviceModelName())
                                    Device OS : \(UIDevice.current.systemVersion)
                                    App Version : \(VersionService.shared.version)
                                    """)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("마이페이지")
            .navigationBarTitleDisplayMode(.inline)
        }
        .showPopupView(isPresented: $isPopUpView, message: .logOut, primaryAction: {
            signStore.logOut()
            path = .init()
        }, secondaryAction: {
            
        })
        .onAppear {
            ViewTracker.shared.updateCurrentView(to: .mypage)
            AnalyticsService.shared.trackView("MypageView")
        }
    }
}

//
//  MyPageView.swift
//  Sachosaeng
//
//  Created by LJh on 7/5/24.
//

import SwiftUI
import WebKit
import SafariServices
import MessageUI

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
    @State var showWK = false
    @State var urlLink = ""
    @State var choosenSettingOption: settingOption = .version
    @State private var showingMailView = false
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
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
                            choosenSettingOption = .userData
                            showWK = true
                        case .service:
                            choosenSettingOption = .service
                            showWK = true
                        case .FAQ:
                            choosenSettingOption = .FAQ
                            showWK = true
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
            .sheet(isPresented: $showWK) {
                switch choosenSettingOption {
                    case .version:
                        EmptyView()
                    case .openSource:
                        EmptyView()
                    case .userData:
                        SafariView(url: URL(string: "https://foregoing-hoof-160.notion.site/d3ea3926640746ce9156fc23251fda7e")!)
                    case .service:
                        SafariView(url: URL(string: "https://foregoing-hoof-160.notion.site/7621154595c445068d833c931a4cefc5?pvs=74")!)
                    case .FAQ:
                        SafariView(url: URL(string: "https://foregoing-hoof-160.notion.site/FAQ-107a24e5b9e88045bd68c6bc5507fd4f")!)
                }
            }
            .sheet(isPresented: $showingMailView) {
                MailView(result: self.$mailResult, recipients: ["dasom8899981@gmail.com"], subject: "1:1 문의", messageBody: """
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
        .onAppear {
            ViewTracker.shared.updateCurrentView(to: .mypage)
        }
    }
}

struct SafariView: UIViewControllerRepresentable {

    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {

    }

}

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?

    var recipients: [String]?
    var subject: String?
    var messageBody: String?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>, result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            if let error = error {
                self.result = .failure(error)
            } else {
                self.result = .success(result)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation, result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(recipients)
        vc.setSubject(subject ?? "")
        vc.setMessageBody(messageBody ?? "", isHTML: false)
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {}
}

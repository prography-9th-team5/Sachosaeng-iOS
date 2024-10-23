//
//  PopupView.swift
//  Sachosaeng
//
//  Created by LJh on 7/25/24.
//

import SwiftUI

enum PopupType: String {
    case quit = "탈퇴 시 동일한 계정으로\n재가입이 불가능해요\n그래도 탈퇴할까요?"
    case saved = "저장 완료!\n확인하러 갈까요?"
    case dailyVote = "오늘의 투표가 도착했어요!"
    case logOut = "정말 로그아웃하시겠어요?"
    case latestVersion = "최신 버전을 사용하시겠어요?"
    case forceUpdate = "최신 버전을 다운받아야 합니다.\n확인 버튼을 누르면 앱스토어로 이동합니다."
    case registration = "투표주제는 모든 사용자가 참여할 수 있도록 적절하고 건전한 내용을 작성해주세요. 등록된 내용은 관리자 검토 후 업로드 됩니다."
    
    var imageFrameWidth: CGFloat {
        switch self {
            case .quit, .registration:
                return 40
            case .dailyVote:
                return 76
            case .saved:
                return 40
            case .logOut, .latestVersion, .forceUpdate:
                return 0
        }
    }
    
    var imageFrameHeight: CGFloat {
        switch self {
            case .quit, .registration:
                return 40
            case .dailyVote:
                return 84
            case .saved:
                return 46
            case .logOut, .latestVersion, .forceUpdate:
                return 0
        }
    }
    var topOfFirstVtackPadding: CGFloat {
        switch self {
            case .quit, .registration:
                return 40
            case .dailyVote:
                return 42
            case .saved:
                return 52
            case .logOut, .latestVersion:
                return 52
            case .forceUpdate:
                return 40
        }
    }
    
    var buttonFrameWitdh: CGFloat {
        switch self {
            case .quit, .saved:
                return 104
            case .dailyVote, .forceUpdate, .registration:
                return 216
            case .logOut, .latestVersion:
                return 104
        }
    }
    
    var primaryButtonText: String {
        switch self {
            case .quit:
                return "확인"
            case .dailyVote, .forceUpdate, .registration:
                return ""
            case .saved, .latestVersion:
                return "취소"
            case .logOut:
                return "확인"
        }
    }
    
    var secondaryButtonText: String {
        switch self {
            case .quit:
                return "취소"
            case .saved:
                return "바로가기"
            case .dailyVote:
                return "투표하기"
            case .logOut:
                return "취소"
            case .forceUpdate, .latestVersion, .registration:
                return "확인"
        }
    }
}

struct PopupView: View {
    @Binding var isPresented: Bool
    let popupType: PopupType
    let primaryAction: () -> Void
    let secondaryAction: () -> Void
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                if popupType != .logOut && popupType != .forceUpdate && popupType != .latestVersion {
                    Image("Popup_\(popupType)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: popupType.imageFrameWidth, height: popupType.imageFrameHeight)
                        .padding(.bottom, 12)
                }
                Text(popupType.rawValue)
                    .font(.createFont(weight: .medium, size: popupType == .registration ? 12 : 14))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .lineSpacing(4)
            }
            .padding(.top, popupType.topOfFirstVtackPadding)
            .padding(.horizontal , 20)
            Spacer()
            HStack(spacing: 8) {
                if popupType != .dailyVote && popupType != .forceUpdate && popupType != .registration {
                    Button {
                        primaryAction()
                        isPresented = false
                    } label: {
                        Text(popupType.primaryButtonText)
                            .font(.createFont(weight: .semiBold, size: 16))
                            .frame(width: popupType.buttonFrameWitdh, height: 47)
                            .background(CustomColor.GrayScaleColor.gs4)
                            .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                            .cornerRadius(4, corners: .allCorners)
                    }
                }
                Button {
                    secondaryAction()
                    isPresented = false
                } label: {
                    Text(popupType.secondaryButtonText)
                        .font(.createFont(weight: .semiBold, size: 16))
                        .foregroundStyle(CustomColor.GrayScaleColor.white)
                        .frame(width: popupType.buttonFrameWitdh, height: 47)
                        .background(CustomColor.GrayScaleColor.black)
                        .cornerRadius(4, corners: .allCorners)
                }
            }
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
        }
        .frame(width: 248, height: setPopUpViewHeight() ? 177 : 248)
        .background(CustomColor.GrayScaleColor.gs3)
        .cornerRadius(8, corners: .allCorners)
        .onAppear{
            if (popupType == .dailyVote || popupType == .registration) && isPresented {
                primaryAction()
            }
        }
    }
    
}

extension PopupView {
    private func setPopUpViewHeight() -> Bool {
        switch popupType {
            case .dailyVote, .registration:
                return false
            case .forceUpdate:
                return true
            case .latestVersion:
                return true
            case .logOut:
                return true
            case .quit:
                return false
            case .saved:
                return false
        }
    }
}

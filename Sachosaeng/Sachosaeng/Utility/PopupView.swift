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
    
    var imageFrameWidth: CGFloat {
        switch self {
            case .quit:
                return 40
            case .dailyVote:
                return 76
            case .saved:
                return 40
        }
    }
    
    var imageFrameHeight: CGFloat {
        switch self {
            case .quit:
                return 40
            case .dailyVote:
                return 84
            case .saved:
                return 46
        }
    }
    var typeRawValueTextWidth: CGFloat {
        switch self {
            case .quit, .dailyVote:
                return 148
            case .saved:
                return 92
        }
    }
    
    var typeRawValueTextHeight: CGFloat {
        switch self {
            case .quit:
                return 54
            case .dailyVote:
                return 12
            case .saved:
                return 32
        }
    }
    
    var topOfFirstVtackPadding: CGFloat {
        switch self {
            case .quit:
                return 40
            case .dailyVote:
                return 42
            case .saved:
                return 52
        }
    }
    
    var buttonFrameWitdh: CGFloat {
        switch self {
            case .quit, .saved:
                return 104
            case .dailyVote:
                return 216
        }
    }
    
    var primaryButtonText: String {
        switch self {
            case .quit:
                return "확인"
            case .dailyVote:
                return ""
            case .saved:
                return "취소"
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
                Image("Popup_\(popupType)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: popupType.imageFrameWidth, height: popupType.imageFrameHeight)
                    .padding(.bottom, 12)
                Text(popupType.rawValue)
                    .font(.createFont(weight: .medium, size: 14))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .lineSpacing(4)
            }
            .padding(.top, popupType.topOfFirstVtackPadding)
            
            Spacer()
            HStack(spacing: 8) {
                if popupType != .dailyVote {
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
        .frame(width: 248, height: 248)
        .background(CustomColor.GrayScaleColor.gs3)
        .cornerRadius(8, corners: .allCorners)
    }
}

#Preview {
    PopupView(isPresented: .constant(true), popupType: .dailyVote) {
        
    } secondaryAction: {
        
    }
}

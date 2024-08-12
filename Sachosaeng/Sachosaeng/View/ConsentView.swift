//
//  ConsentView.swift
//  Sachosaeng
//
//  Created by LJh on 8/8/24.
//

import SwiftUI

enum ConsentOption: String, CaseIterable {
    case agreeAll = "필수 약관 모두 동의"
    case agreePrivacy = "개인정보 수집 및 이용 동의 (필수)"
    case agreeService = "서비스 약관 모두 동의 (필수)"
}

struct ConsentView: View {
    @Binding var isFirstLaunch: Bool
    @State var isSelected: Bool = false
    @State private var toast: Toast? = nil
    @State private var consentSelections: [Bool] = Array(repeating: false, count: ConsentOption.allCases.count)
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                CommonTitle(top: "서비스 이용에", topFont: .bold, middle: "동의해 주세요", middleFont: .bold, footer: "", footerFont: .black, isSuccessView: false)
                
                ForEach(ConsentOption.allCases.indices, id: \.self) { index in
                    Button {
                        if index == 0 {
                            // 첫 번째 옵션 클릭 시, 모든 옵션의 상태를 일괄 변경
                            let newState = !consentSelections[0]
                            consentSelections = Array(repeating: newState, count: consentSelections.count)
                        } else {
                            // 첫 번째 이외의 옵션 클릭 시, 해당 옵션의 상태만 변경
                            consentSelections[index].toggle()
                            
                            // 나머지 옵션들이 모두 선택되었는지 확인
                            let allSelected = consentSelections.dropFirst().allSatisfy { $0 }
                            consentSelections[0] = allSelected
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: PhoneSpace.screenWidth - 40, height: 60)
                            .foregroundStyle(index != 0 ?
                                             CustomColor.GrayScaleColor.white :
                                             CustomColor.GrayScaleColor.gs2
                            )
                            .overlay {
                                HStack(spacing: 0) {
                                    Image(consentSelections[index] ? "check_on" : "check_off")
                                    Text(ConsentOption.allCases[index].rawValue)
                                        .padding(.horizontal, 10)
                                        .font(.createFont(weight: .medium, size: 15))
                                        .foregroundStyle(CustomColor.GrayScaleColor.black)
                                    Spacer()
                                    if index > 0 {
                                        Image("arrowRight")
                                            .padding(.horizontal, 16)
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                    }
                }
            }
            .padding(.top, 62)
            Spacer()
            Button {
                toast = Toast(type: .saved, message: "약관에 동의하셨어요")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isFirstLaunch = false
                }
                
            } label: {
                Text("다음")
                    .frame(width: PhoneSpace.screenWidth * 0.9, height: 47)
                    .foregroundStyle(CustomColor.GrayScaleColor.white)
                    .background(consentSelections[0] ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs4)
                    .cornerRadius(4)
            }
        }
        .showToastView(toast: $toast)
    }
}

#Preview {
    ConsentView(isFirstLaunch: .constant(false))
}

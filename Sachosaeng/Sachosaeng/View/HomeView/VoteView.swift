//
//  VoteView.swift
//  Sachosaeng
//
//  Created by LJh on 6/27/24.
//

import SwiftUI

struct VoteView: View {
    @State var isSelected: Bool = false
    @State var isBookmark: Bool = false
    @State var isPressSuccessButton: Bool = false
    @State private var selectedIndex: Int? = nil
    var body: some View {
       ZStack {  
           CustomColor.GrayScaleColor.gs2.ignoresSafeArea()
           VStack(spacing: 0) {
               ScrollView {
                    VStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: 0)
                            .cornerRadius(8, corners: [.topLeft, .topRight])
                            .foregroundStyle(CustomColor.PrimaryColor.primaryColorWithAlpha(.red))
                            .frame(width: PhoneSpace.screenWidth - 40, height: 68)
                            .overlay(alignment: .leading) {
                                // TODO: - 앞전에 메인홈에서 카테고리이름대로 여기다가 넣어야함
                                Image(systemName: "bolt")
                                    .padding(.leading, 20)
                            }
                            .overlay(alignment: .trailing) {
                                Button {
                                    isBookmark.toggle()
                                } label: {
                                    Image(isBookmark ? "bookmark" : "bookmark_off")
                                        .padding(.trailing, 20)
                                }
                            }
                        
                        RoundedRectangle(cornerRadius: 0)
                            .foregroundStyle(CustomColor.GrayScaleColor.white)
                            .cornerRadius(8, corners: [.bottomLeft, .bottomRight])
                            .frame(width: PhoneSpace.screenWidth - 40, height: isPressSuccessButton ? 410 : 370)
                            .overlay(alignment: .top) {
                                VStack(spacing: 0) {
                                    Text("친한 사수 결혼식 축의금을 얼마 내면 좋을까요?")
                                        .font(.createFont(weight: .bold, size: 18))
                                        .frame(width: PhoneSpace.screenWidth - 80, alignment: .leading)
                                        .padding(.bottom, 13)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Text("1000명 참여 중")
                                        .font(.createFont(weight: .medium, size: 14))
                                        .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                                        .frame(width: PhoneSpace.screenWidth - 80, alignment: .leading)
                                        .padding(.bottom, 25)
                                    
                                    VStack(spacing: 8) {
                                        ForEach(0..<4) { num in
                                            RoundedRectangle(cornerRadius: 4)
                                                .frame(width: PhoneSpace.screenWidth - 80, height: 50)
                                                .foregroundStyle(CustomColor.GrayScaleColor.gs3)
                                                .overlay(alignment: .leading) {
                                                    HStack(spacing: 0) {
                                                        Text("데이터 연결하면 바꿀거임 ")
                                                            .padding(.leading, 16)
                                                    }
                                                }
                                                .border(selectedIndex == num ? Color.black : Color.clear, width: 1)
                                                .onTapGesture {
                                                    isSelected = true
                                                    selectedIndex = num
                                                }
                                        }
                                        
                                        if isPressSuccessButton {
                                            HStack {
                                                Text("사용자 데이터를 기반으로 제공되는 결과이며,\n판단에 도움을 주기 위한 참고 자료로 활용해 주세요.")
                                                    .font(.createFont(weight: .medium, size: 12))
                                                    .foregroundStyle(CustomColor.GrayScaleColor.gs5)
                                                    .lineLimit(2)
                                                Spacer()
                                            }
                                            .padding(.top, 7)
                                        }
                                    }
                                }
                                .frame(width: PhoneSpace.screenWidth - 80)
                                .padding(.top, 26)
                                .padding(.horizontal, 20)
                            }
                        if isPressSuccessButton {
                            HStack(spacing: 0) {
                                Image("vote_학생")
                                VStack(spacing: 0) {
                                    Text("데이터 연결하면 바꿀거임")
                                        .font(.createFont(weight: .medium, size: 14))
                                    Text("데이터 연결하면 바꿀거임")
                                        .font(.createFont(weight: .medium, size: 14))
                                    
                                }
                                .padding(.leading, 4.5)
                                Spacer()
                            }
                            .padding()
                        }
                        Spacer()
                        
                    } //: Vstack
                    .padding(.top, 26)
                    .navigationTitle("# 경조사")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden()
                    .customBackbutton()
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                
                            } label: {
                                Image("Progressbaricon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            }
                        }
                    }
                   
//                   if isPressSuccessButton {
//                       VStack(spacing: 0) {
//                           HStack {
//                               Text("연관 콘텐츠")
//                                   .font(.createFont(weight: .bold, size: 18))
//                               Spacer()
//                           }
//                           
//                       }
//                   }
               } //: ScrollView
               Button {
                   isPressSuccessButton = true
               } label: {
                   Text("확인")
               }
               .frame(width: PhoneSpace.screenWidth - 40, height: 47)
               .foregroundStyle(CustomColor.GrayScaleColor.white)
               .background(isSelected ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs4)
               .cornerRadius(4)
           } //: Vstack
        } //: Zstack
    }
}

#Preview {
    NavigationStack {
        VoteView()
    }
}

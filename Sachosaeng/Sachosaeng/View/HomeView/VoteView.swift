//
//  VoteView.swift
//  Sachosaeng
//
//  Created by LJh on 6/27/24.
//

import SwiftUI

struct VoteView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isSelected: Bool = false
    var backButton : some View {
        Button(
            action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.backward")
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.black)
            }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 0)
                .cornerRadius(8, corners: [.topLeft, .topRight])
                .foregroundStyle(CustomColor.PrimaryColor.primaryColorWithAlpha(.red))
                .frame(width: PhoneSpace.screenWidth - 40, height: 68)
                .overlay(alignment: .leading) {
                    Image(systemName: "bolt")
                        .padding(.leading, 20)
                }
                .overlay(alignment: .trailing) {
                    Button {
                         
                    } label: {
                        Image(systemName: "bookmark")
                            .padding(.trailing, 20)
                    }
                }
           
            RoundedRectangle(cornerRadius: 0)
                .foregroundStyle(CustomColor.GrayScaleColor.gs3)
                .cornerRadius(8, corners: [.bottomLeft, .bottomRight])
                .frame(width: PhoneSpace.screenWidth - 40, height: 370)
                .overlay {
                    VStack(spacing: 0) {
                        Text("친한 사수 결혼식 축의금을 얼마 내면 좋을까요?")
                            .font(.createFont(weight: .bold, size: 18))
                            .frame(width: PhoneSpace.screenWidth - 80, alignment: .leading)
                            .padding(.bottom, 16)
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
                            }
                        }
                    }
                    .frame(width: PhoneSpace.screenWidth - 80)
                    .padding(.vertical, 26)
                    .padding(.horizontal, 20)
                }
            Spacer()
            Button {
                
            } label: {
                Text("확인")
            }
            .frame(width: PhoneSpace.screenWidth - 40, height: 47)
            .foregroundStyle(CustomColor.GrayScaleColor.white)
            .background(isSelected ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs4)
            .cornerRadius(4)
        }
        .padding(.top, 26)
        .navigationTitle("# 경조사")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar() {
            ToolbarItem(placement: .topBarLeading) {
                backButton
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
        
    }
}

#Preview {
    NavigationStack {
        VoteView()
    }
}

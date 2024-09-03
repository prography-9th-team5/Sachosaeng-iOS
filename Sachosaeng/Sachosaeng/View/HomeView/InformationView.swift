//
//  InformationView.swift
//  Sachosaeng
//
//  Created by LJh on 8/31/24.
//

import SwiftUI

struct InformationView: View {
    @StateObject var voteStore: VoteStore
    var informationId: Int

    var body: some View {
        ZStack {
            CustomColor.GrayScaleColor.gs2.ignoresSafeArea()
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        if let information = voteStore.currentVoteInformationDetail {
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Text(information.title)
                                        .font(.createFont(weight: .bold, size: 22))
                                        .foregroundStyle(CustomColor.GrayScaleColor.black)
                                    Spacer()
                                }
                                .padding(.bottom, 28)
                                
                                VStack(spacing: 0) {
                                    Text(information.subtitle ?? "")
                                        .foregroundStyle(CustomColor.GrayScaleColor.black)
                                        .font(.createFont(weight: .medium, size: 16))
                                    
                                    let modifiedContent = information.content
                                        .replacingOccurrences(of: "\n", with: "\n")
                                    
                                    Text(modifiedContent)
                                        .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                                        .font(.createFont(weight: .medium, size: 14))
                                }
                                .padding(.horizontal, 16)
                                .padding(.top, 8)
                                .padding(.bottom, 24)
                                .background(CustomColor.GrayScaleColor.gs1)
                                .cornerRadius(8, corners: [.allCorners])
                                
                                HStack(spacing: 0) {
                                    Text(information.referenceName)
                                        .foregroundStyle(CustomColor.GrayScaleColor.gs5)
                                        .font(.createFont(weight: .medium, size: 12))
                                    Spacer()
                                }
                                .padding(.top, 20)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(CustomColor.GrayScaleColor.white)
            .padding(.top, 10)
        }
        .toolbar {
            Text("asdsa")
        }
        .navigationTitle("연관 콘텐츠")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .navigationBarTitleTextColor(CustomColor.GrayScaleColor.gs6, .medium, size: 18)
        .customBackbutton()
        .onAppear {
            
            voteStore.fetchInformation(informationId: informationId)
        }
    }
}

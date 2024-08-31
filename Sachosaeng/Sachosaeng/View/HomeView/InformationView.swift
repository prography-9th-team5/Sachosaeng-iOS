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
            CustomColor.GrayScaleColor.white.ignoresSafeArea()
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
                                
                                RoundedRectangle(cornerRadius: 8) 
                                    .frame(height: 500)
                                    .foregroundStyle(CustomColor.GrayScaleColor.gs1)
                                    .overlay {
                                        VStack(spacing: 0) {
                                            Text(information.subtitle ?? "")
                                            Text(information.content)
                                            Text(information.referenceName)
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            .padding()
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

//
//  InformationView.swift
//  Sachosaeng
//
//  Created by LJh on 8/31/24.
//

import SwiftUI

struct InformationView: View {
    @ObservedObject var voteStore: VoteStore
    @ObservedObject var bookmarkStore: BookmarkStore
    @State var isBookmark: Bool = false
    var informationId: Int

    var body: some View {
        ZStack {
            CustomColor.GrayScaleColor.gs2.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Text("\(voteStore.currentVoteInformationDetail.title)")
                        .font(.createFont(weight: .bold, size: 22))
                        .foregroundStyle(CustomColor.GrayScaleColor.black)
                        .lineLimit(3)
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        VStack(spacing: 0) {
                            Text(voteStore.currentVoteInformationDetail.subtitle ?? "")
                                .foregroundStyle(CustomColor.GrayScaleColor.black)
                                .font(.createFont(weight: .medium, size: 16))
                            
                            let modifiedContent = voteStore.currentVoteInformationDetail.content
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
                            Text(voteStore.currentVoteInformationDetail.referenceName)
                                .foregroundStyle(CustomColor.GrayScaleColor.gs5)
                                .font(.createFont(weight: .medium, size: 12))
                                .underline()
                            Spacer()
                        }
                        .padding(.top, 20)
                    }
                }
                .padding()
            }
            .background(CustomColor.GrayScaleColor.white)
            .padding(.top, 10)
        }
        .toolbar {
            Button {
                if voteStore.currentVoteInformationDetail.isBookmarked {
                    bookmarkStore.deleteInformationsInBookmark(informationId: informationId)
                } else {
                    bookmarkStore.updateInformationsInBookmark(informationId: informationId)
                }
                voteStore.currentVoteInformationDetail.isBookmarked.toggle()
            } label: {
                Image(voteStore.currentVoteInformationDetail.isBookmarked ? "bookmark" : "bookmark_off")
                    .frame(width: 16, height: 18)
                    .padding(.trailing, 20)
            }
        
        }
        .navigationTitle("연관 콘텐츠")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .navigationBarTitleTextColor(CustomColor.GrayScaleColor.gs6, .medium, size: 18)
        .customBackbutton()
        .onAppear {
            ViewTracker.shared.updateCurrentView(to: .information)
            voteStore.fetchInformation(informationId: informationId)
            AnalyticsService.shared.trackView("InformationView")

        }
    }
}

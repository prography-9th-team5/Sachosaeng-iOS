//
//  VoteHistoryView.swift
//  Sachosaeng
//
//  Created by LJh on 10/24/24.
//

import SwiftUI

struct VoteHistoryView: View {
    @ObservedObject var voteStore: VoteStore
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            CustomColor.GrayScaleColor.gs2.ignoresSafeArea()
            VStack(spacing: 0) {
                ScrollView {
                    ForEach(voteStore.registeredHistory) { vote in
                        Button {
                            path.append(PathType.registeredVotes(vote.voteId))
                        } label: {
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Text(vote.title)
                                        .font(.createFont(weight: .bold, size: 14))
                                        .foregroundStyle(CustomColor.GrayScaleColor.black)
                                    Spacer()
                                }
                                .padding(.bottom, 14)
                                HStack(spacing: 0) {
                                    Image("history_\(vote.status)")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 8, height: 8)
                                        .padding(.trailing, 4)
                                    
                                    
                                    Text(setHistoryCellText(vote: vote))
                                        .font(.createFont(weight: .medium, size: 12))
                                        .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                                    Spacer()
                                }
                            }
                            .padding(16)
                            .frame(width: PhoneSpace.screenWidth - 40, height: 66)
                            .background(CustomColor.GrayScaleColor.white)
                            .cornerRadius(8, corners: .allCorners)
                        }
                        
                    }
                }
                .padding()
            }
        }
        .navigationTitle("투표 등록 히스토리")
        .navigationBarTitleTextColor(CustomColor.GrayScaleColor.gs6, .bold, size: 18)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            voteStore.fetchHistory()
        }
    }
}

extension VoteHistoryView {
    private func setHistoryCellText(vote: History) -> String {
        switch vote.status {
            case "PENDING":
                return "사초생 검토 중"
            case "APPROVED":
                return "투표 등록 완료"
            case "REJECTED":
                return "투표 등록 실패"
            default:
                return ""
        }
    }
}

//
//  VoteView.swift
//  Sachosaeng
//
//  Created by LJh on 6/27/24.
//

import SwiftUI

struct DailyVoteView: View {
    @State private var toast: Toast? = nil
    @State var isSelected: Bool = false
    @State var isBookmark: Bool = false
    @State var isPressSuccessButton: Bool = false
    @State var chosenVoteIndex: Int?
    @State var chosenVoteOptionId: [Int] = []
    @StateObject var voteStore: VoteStore
    
    var body: some View {
        ZStack {
            CustomColor.GrayScaleColor.gs2.ignoresSafeArea()
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: 0)
                            .cornerRadius(8, corners: [.topLeft, .topRight])
                            .foregroundStyle(Color(hex: voteStore.currentDailyVoteDetail.category.backgroundColor))
                            .frame(width: PhoneSpace.screenWidth - 40, height: 68)
                            .overlay(alignment: .leading) {
                                AsyncImage(url: URL(string: "\(voteStore.currentDailyVoteDetail.category.iconUrl)")) { phase in
                                    switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 32, height: 32)
                                                .padding()
                                        case .failure(let error):
                                            Text("Failed to load image: \(error.localizedDescription)")
                                        @unknown default:
                                            Text("Unknown state")
                                    }
                                }
                            }
                            .overlay(alignment: .trailing) {
                                Button {
                                    isBookmark.toggle()
                                } label: {
                                    Image(isBookmark ? "bookmark" : "bookmark_off")
                                        .frame(width: 16, height: 18)
                                        .padding(.trailing, 20)
                                }
                            }
                        
                        RoundedRectangle(cornerRadius: 0)
                            .foregroundStyle(CustomColor.GrayScaleColor.white)
                            .cornerRadius(8, corners: [.bottomLeft, .bottomRight])
                            .frame(width: PhoneSpace.screenWidth - 40, height: isPressSuccessButton ? 390 : 350)
                            .overlay(alignment: .top) {
                                VStack(spacing: 0) {
                                    Text(voteStore.currentDailyVoteDetail.title)
                                        .font(.createFont(weight: .bold, size: 18))
                                        .frame(width: PhoneSpace.screenWidth - 80, alignment: .leading)
                                        .padding(.bottom, 13)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Text("\(voteStore.currentDailyVoteDetail.participantCount)명 참여 중")
                                        .font(.createFont(weight: .medium, size: 14))
                                        .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                                        .frame(width: PhoneSpace.screenWidth - 80, alignment: .leading)
                                        .padding(.bottom, 25)
                                    
                                    VStack(spacing: 8) {
                                        ForEach(voteStore.currentDailyVoteDetail.voteOptions) { vote in
                                            RoundedRectangle(cornerRadius: 4)
                                                .frame(width: PhoneSpace.screenWidth - 80, height: 50)
                                                .foregroundStyle(vote.voteOptionId == chosenVoteIndex ?  CustomColor.GrayScaleColor.gs3 : CustomColor.GrayScaleColor.gs2)
                                                .overlay(alignment: .leading) {
                                                    HStack(spacing: 0) {
                                                        Text(vote.content)
                                                            .padding(.leading, 16)
                                                    }
                                                }
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .stroke(vote.voteOptionId == chosenVoteIndex ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs3, lineWidth: 1)
                                                }
                                                .onTapGesture {
                                                    isSelected = true
                                                    chosenVoteIndex = vote.voteOptionId
                                                    
                                                    if chosenVoteIndex == vote.voteOptionId {
                                                        chosenVoteOptionId.append(vote.voteOptionId)
                                                    } else {
                                                        if let index = chosenVoteOptionId.firstIndex(of: vote.voteOptionId) {
                                                            chosenVoteOptionId.remove(at: index)
                                                        }
                                                    }
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
                                Image("vote_\(UserStore.shared.currentUserState.userType)")
                                VStack(spacing: 0) {
                                    Text("나와 같은 \(UserStore.shared.currentUserState.userType)은\n여기는 투표 많이 뽑힌걸로 넣어야함")
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
                    .navigationTitle("경조사")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden()
                    .customBackbutton()
                } //: ScrollView
                Button {
                    if isPressSuccessButton {
                        
                    } else {
                        isPressSuccessButton = true
                        voteStore.updateUserVoteChoices(voteId: voteStore.currentDailyVoteDetail.voteId, chosenVoteOptionIds: chosenVoteOptionId)
                        toast = Toast(type: .success, message: "투표 완료!")
                    }
                } label: {
                    Text(isPressSuccessButton ? "다른 투표 보기" : "확인")
                        .frame(width: PhoneSpace.screenWidth - 40, height: 47)
                        .foregroundStyle(CustomColor.GrayScaleColor.white)
                        .background(isSelected ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs4)
                        .cornerRadius(4)
                }
                .contentShape(Rectangle())
            } //: Vstack
            .showToastView(toast: $toast)
        } //: Zstack
        .onAppear {
            voteStore.fetchVoteDetail(voteId: voteStore.dailyVote.voteId)
        }
    }
}

#Preview {
    NavigationStack {
        DailyVoteView( voteStore: VoteStore())
    }
}

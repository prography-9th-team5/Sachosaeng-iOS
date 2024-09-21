//
//  DailyVoteDetailView.swift
//  Sachosaeng
//
//  Created by LJh on 9/19/24.
//

import SwiftUI
import Lottie

struct DailyVoteDetailView: View {
    @ObservedObject var voteStore: VoteStore
    @ObservedObject var bookmarkStore: BookmarkStore
    @EnvironmentObject var tabBarStore: TabBarStore
    @State var voteId: Int
    @Binding var path: NavigationPath
    @State private var toast: Toast? = nil
    @State private var isSelected: Bool = false
    @State private var isBookmark: Bool = false
    @State private var isVoted: Bool = false
    @State private var chosenVoteIndex: Int?
    @State private var chosenVoteOptionId: [Int] = []
    @State private var isLottie: Bool = false
    @State private var isLoading: Bool = true
    
    var body: some View {
        ZStack {
            CustomColor.GrayScaleColor.gs2.ignoresSafeArea()
            
            if isLottie {
                LottieView(animation: .named("stamplottie"))
                    .playing()
            }
            
            VStack(spacing: 0) {
                ScrollViewReader{ proxy in
                    ScrollView {
                        VStack(spacing: 0) {
                            RoundedRectangle(cornerRadius: 0)
                                .cornerRadius(8, corners: [.topLeft, .topRight])
                                .foregroundStyle(Color(hex: voteStore.currentVoteDetail.category.backgroundColor))
                                .frame(width: PhoneSpace.screenWidth - 40, height: 68)
                                .overlay(alignment: .leading) {
                                    AsyncImage(url: URL(string: "\(voteStore.currentVoteDetail.category.iconUrl)")) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 32, height: 32)
                                            .padding()
                                    } placeholder: {
                                        ProgressView()
                                            .scaledToFit()
                                            .frame(width: 32, height: 32)
                                            .padding()
                                    }
                                }
                                .overlay(alignment: .trailing) {
                                    Button {
                                        voteStore.currentVoteDetail.isBookmarked
                                        ? bookmarkStore.deleteVotesBookmark(voteId: voteId)
                                        : bookmarkStore.updateVotesBookmark(voteId: voteId)
                                        
                                        voteStore.currentVoteDetail.isBookmarked.toggle()
                                        isBookmark = voteStore.currentVoteDetail.isBookmarked
                                        
                                        if isBookmark {
                                            tabBarStore.isOpacity = false
                                            toast = Toast(type: .savedBookMark, message: "저장 완료!")
                                        }
                                    } label: {
                                        Image(voteStore.currentVoteDetail.isBookmarked ? "bookmark" : "bookmark_off")
                                            .frame(width: 16, height: 18)
                                            .padding(.trailing, 20)
                                    }
                                }
                            
                            VStack(spacing: 0) {
                                Text(voteStore.currentVoteDetail.title)
                                    .font(.createFont(weight: .bold, size: 18))
                                    .frame(width: PhoneSpace.screenWidth - 80, alignment: .leading)
                                    .padding(.bottom, 13)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Text("\(voteStore.currentVoteDetail.participantCount)명 참여 중")
                                    .font(.createFont(weight: .medium, size: 14))
                                    .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                                    .frame(width: PhoneSpace.screenWidth - 80, alignment: .leading)
                                    .padding(.bottom, 25)
                                
                                VStack(spacing: 8) {
                                    ForEach(voteStore.currentVoteDetail.voteOptions) { vote in
                                        let isChosenOption = voteStore.currentVoteDetail.isMultipleChoiceAllowed
                                            ? chosenVoteOptionId.contains(vote.voteOptionId)
                                            : vote.voteOptionId == chosenVoteIndex
                                        if isVoted {
                                            RoundedRectangle(cornerRadius: 4)
                                                .frame(width: PhoneSpace.screenWidth - 80, height: 50)
                                                .foregroundStyle(isChosenOption ?  CustomColor.GrayScaleColor.gs6 : CustomColor.GrayScaleColor.gs2)
                                                .overlay(alignment: .leading) {
                                                    HStack(spacing: 0) {
                                                        Image(isChosenOption ? "check_white" : "check_off")
                                                        Text(vote.content)
                                                            .font(.createFont(weight: isChosenOption ? .semiBold : .medium, size: 16))
                                                            .foregroundStyle(isChosenOption ? CustomColor.GrayScaleColor.white : CustomColor.GrayScaleColor.black)
                                                            .padding(.leading, 8)
                                                            .lineLimit(2)
                                                    }
                                                    .padding(.leading, 8)
                                                }
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .stroke(isChosenOption ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs3, lineWidth: 1)
                                                }
                                        } else {
                                            RoundedRectangle(cornerRadius: 4)
                                                .frame(width: PhoneSpace.screenWidth - 80, height: 50)
                                                .foregroundStyle(isChosenOption ?  CustomColor.GrayScaleColor.gs6 : CustomColor.GrayScaleColor.gs2)
                                                .overlay(alignment: .leading) {
                                                    HStack(spacing: 0) {
                                                        Image(isChosenOption ? "check_white" : "check_off")
                                                        Text(vote.content)
                                                            .font(.createFont(weight: isChosenOption ? .semiBold : .medium, size: 16))
                                                            .foregroundStyle(isChosenOption ? CustomColor.GrayScaleColor.white : CustomColor.GrayScaleColor.black)
                                                            .padding(.leading, 8)
                                                            .lineLimit(2)
                                                    }
                                                    .padding(.leading, 8)
                                                }
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .stroke(isChosenOption ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs3, lineWidth: 1)
                                                }
                                                .onTapGesture {
//                                                    isSelected = true
//                                                    chosenVoteIndex = vote.voteOptionId
//                                                    
//                                                    if chosenVoteIndex == vote.voteOptionId {
//                                                        chosenVoteOptionId.append(vote.voteOptionId)
//                                                    } else {
//                                                        if let index = chosenVoteOptionId.firstIndex(of: vote.voteOptionId) {
//                                                            chosenVoteOptionId.remove(at: index)
//                                                        }
//                                                    }
                                                    if voteStore.currentVoteDetail.isMultipleChoiceAllowed {
                                                        if isChosenOption {
                                                            if let index = chosenVoteOptionId.firstIndex(of: vote.voteOptionId) {
                                                                chosenVoteOptionId.remove(at: index)
                                                                if chosenVoteOptionId.isEmpty { isSelected = false }
                                                            }
                                                        } else {
                                                            isSelected = true
                                                            chosenVoteOptionId.append(vote.voteOptionId)
                                                        }
                                                    } else {
                                                        if chosenVoteIndex == vote.voteOptionId {
                                                            if let index = chosenVoteOptionId.firstIndex(of: vote.voteOptionId) {
                                                                chosenVoteIndex = nil
                                                                chosenVoteOptionId.remove(at: index)
                                                            }
                                                            isSelected = false
                                                        } else {
                                                            chosenVoteIndex = vote.voteOptionId
                                                            chosenVoteOptionId.append(vote.voteOptionId)
                                                            isSelected = true
                                                        }
                                                    }
                                                
                                                
                                                }
                                        }
                                    }
                                    if isVoted { VoteDescriptionView() }
                                }
                                .padding(.bottom, 20)
                            }
                            .frame(width: PhoneSpace.screenWidth - 80)
                            .padding(.top, 26)
                            .padding(.horizontal, 20)
                            .background(CustomColor.GrayScaleColor.white)
                            .cornerRadius(8, corners: [.bottomLeft, .bottomRight])
                            
                        } //: Vstack
                        .padding(.top, 26)
                        .navigationTitle("경조사")
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarBackButtonHidden()
                        .customBackbutton()
                    }//: ScrollView
                    
                    Button {
                        if isVoted {
                            tabBarStore.isOpacity = false
                            path.removeLast()
                            
                        } else {
                            isVoted = true
                            isLottie = true
                            voteStore.searchInformation(categoryId: voteStore.currentVoteDetail.category.categoryId, voteId: voteStore.currentVoteDetail.voteId) { success in
                                if success {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        isLottie = false
                                        voteStore.updateUserVoteChoices(voteId: voteStore.currentVoteDetail.voteId, chosenVoteOptionIds: chosenVoteOptionId) { isSuccess in
                                            toast = Toast(type: .quit, message: "투표 완료!")
                                        }
                                    }
                                } else {
                                    isLottie = false
                                    toast = Toast(type: .quit, message: "투표 실패")
                                }
                            }
                        }
                    } label: {
                        Text(isVoted ? "확인" : "선택 확인")
                            .frame(width: PhoneSpace.screenWidth - 40, height: 47)
                            .foregroundStyle(CustomColor.GrayScaleColor.white)
                            .background(isSelected ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs4)
                            .cornerRadius(4)
                    }
                    .contentShape(Rectangle())
                }
            } //: Vstack
            .showToastView(toast: $toast)
            .opacity(isLottie ? 0 : 1)
            .redacted(reason: isLoading ? .placeholder : [])
        } //: Zstack
        .showPopupView(isPresented: $isBookmark, message: .saved, primaryAction: {}, secondaryAction: {
            path.append(PathType.home)
            tabBarStore.switchTab = .bookMark
        })
        .showToastView(toast: $toast)
        .onAppear {
            Task {
                voteStore.fetchVoteDetail(voteId: voteId) { _ in
                    isLoading = false
                }
            }
        }
    }
}

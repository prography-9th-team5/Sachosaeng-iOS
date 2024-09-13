//
//  PopularVoteView.swift
//  Sachosaeng
//
//  Created by LJh on 8/25/24.
//

import SwiftUI
import Lottie

struct VoteDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var toast: Toast? = nil
    @State private var isSelected: Bool = false
    @State private var isBookmark: Bool = false
    @State private var isVoted: Bool = false
    @State private var chosenVoteIndex: Int?
    @State private var chosenVoteOptionId: [Int] = []
    @State var voteId: Int
    @State private var isLottie: Bool = false
    @StateObject var voteStore: VoteStore
    @StateObject var bookmarkStore: BookmarkStore
    
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
                                        if voteStore.currentVoteDetail.isBookmarked {
                                            bookmarkStore.deleteVotesBookmark(voteId: voteId)
                                        } else {
                                            bookmarkStore.updateVotesBookmark(voteId: voteId)
                                        }
                                        voteStore.currentVoteDetail.isBookmarked.toggle()
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
                                        RoundedRectangle(cornerRadius: 4)
                                            .frame(width: PhoneSpace.screenWidth - 80, height: 50)
                                            .foregroundStyle(vote.voteOptionId == chosenVoteIndex ?  CustomColor.GrayScaleColor.gs3 : CustomColor.GrayScaleColor.gs2)
                                            .overlay(alignment: .leading) {
                                                HStack(spacing: 0) {
                                                    Text(vote.content)
                                                        .padding(.leading, 16)
                                                        .lineLimit(2)
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
                                    if isVoted { VoteDescriptionView() }
                                }
                                .padding(.bottom, 20)
                            }
                            .frame(width: PhoneSpace.screenWidth - 80)
                            .padding(.top, 26)
                            .padding(.horizontal, 20)
                            .background(CustomColor.GrayScaleColor.white)
                            .cornerRadius(8, corners: [.bottomLeft, .bottomRight])

                            if isVoted {
                                VoteResultView(description: voteStore.currentVoteDetail.description)
                                    .padding(.bottom, 40)
                                HStack(spacing: 0) {
                                    Text("연관 콘텐츠")
                                        .font(.createFont(weight: .bold, size: 18))
                                        .foregroundStyle(CustomColor.GrayScaleColor.black)
                                    Spacer()
                                }
                                .padding(.leading, 20)
                                .padding(.bottom, 14)
                                VStack(spacing: 0) {
                                    ForEach(voteStore.currentVoteInformation) { information in
                                        NavigationLink {
                                            InformationView(voteStore: voteStore, bookmarkStore: bookmarkStore, informationId: information.id)
                                        } label: {
                                            RoundedRectangle(cornerRadius: 8)
                                                .foregroundStyle(CustomColor.GrayScaleColor.white)
                                                .frame(height: 60)
                                                .overlay {
                                                    HStack(spacing: 0) {
                                                        Text(information.title)
                                                            .foregroundStyle(CustomColor.GrayScaleColor.black)
                                                            .font(.createFont(weight: .medium, size: 15))
                                                        Spacer()
                                                    }
                                                    .padding(.leading, 16)
                                                }
                                                .padding(.horizontal, 20)
                                                .padding(.bottom, 6)
                                        }
                                    }
                                }
                            }
                            Spacer()
                        } //: Vstack
                        .padding(.top, 26)
                        .navigationTitle("경조사")
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarBackButtonHidden()
                        .customBackbutton()
                        
                        Spacer()
                            .frame(height: 128)
                            .id("bottom")
                    }//: ScrollView
                
                Button {
                    if isVoted {
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        isVoted = true
                        isLottie = true
                        voteStore.searchInformation(categoryId: voteStore.currentVoteDetail.category.categoryId, voteId: voteStore.currentVoteDetail.voteId) { success in
                            if success {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        proxy.scrollTo("bottom")
                                    }
                                    isLottie = false
                                    voteStore.updateUserVoteChoices(voteId: voteStore.currentVoteDetail.voteId, chosenVoteOptionIds: chosenVoteOptionId)
                                    toast = Toast(type: .quit, message: "투표 완료!")
                                }
                            } else {
                                isLottie = false
                                toast = Toast(type: .quit, message: "투표 실패")
                            }
                        }
                    }
                } label: {
                    Text(isVoted ? "다른 투표 보기" : "확인")
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
        } //: Zstack
        .onAppear {
            Task {
                voteStore.fetchVoteDetail(voteId: voteId)
            }
        }
    }
}

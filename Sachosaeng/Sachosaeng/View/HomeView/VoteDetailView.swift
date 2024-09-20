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
    @State private var isLoading: Bool = true
    @ObservedObject var voteStore: VoteStore
    @StateObject var bookmarkStore: BookmarkStore
    @EnvironmentObject var tabBarStore: TabBarStore
    @State private var animatedPercentages: [Int: CGFloat] = [:]

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
                                        let totalVotes = voteStore.currentVoteDetail.voteOptions.map { $0.count }.reduce(0, +)
                                          
                                        let votePercentage = totalVotes > 0 ? CGFloat(vote.count) / CGFloat(totalVotes) : 0
                                        // 다중 선택 여부에 따라 선택된 옵션을 관리
                                        let isChosenOption = voteStore.currentVoteDetail.isMultipleChoiceAllowed
                                            ? chosenVoteOptionId.contains(vote.voteOptionId)
                                            : vote.voteOptionId == chosenVoteIndex

                                        ZStack(alignment: .leading) {
                                            if isVoted {
                                                // 투표 완료 후
                                                RoundedRectangle(cornerRadius: 4)
                                                    .stroke(isChosenOption ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs3, lineWidth: 0)
                                                    .frame(width: PhoneSpace.screenWidth - 80, height: 50)
                                                    .background(isChosenOption ? CustomColor.GrayScaleColor.gs5 : CustomColor.GrayScaleColor.gs3)
                                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                                                
                                                RoundedRectangle(cornerRadius: 4)
                                                    .fill(isChosenOption ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs4)
                                                    .frame(width: (PhoneSpace.screenWidth - 80) * (animatedPercentages[vote.voteOptionId] ?? 0), height: 50)
                                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                                                    .onAppear {
                                                        
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                            withAnimation(.easeInOut(duration: 2.8)) {
                                                                animatedPercentages[vote.voteOptionId] = votePercentage
                                                            }
                                                        }
                                                    }
                                                HStack {
                                                    Text(vote.content)
                                                        .foregroundColor(isChosenOption ? .white : .black)
                                                        .font(.createFont(weight: isChosenOption ? .bold : .medium, size: 14))
                                                        .padding(.leading, 16)
                                                        .lineLimit(2)
                                                    Spacer()
                                                    Text(String(format: "%.0f%%", votePercentage * 100))
                                                        .foregroundColor(isChosenOption ? .white : .black)
                                                        .font(.createFont(weight: isChosenOption ? .bold : .medium, size: 14))
                                                        .padding(.trailing, 16)
                                                }
                                            } else {
                                                // 투표 완료 전
                                                RoundedRectangle(cornerRadius: 4)
                                                    .frame(width: PhoneSpace.screenWidth - 80, height: 50)
                                                    .foregroundStyle(isChosenOption ? CustomColor.GrayScaleColor.gs3 : CustomColor.GrayScaleColor.gs2)
                                                    .overlay(alignment: .leading) {
                                                        HStack(spacing: 0) {
                                                            Text(vote.content)
                                                                .padding(.leading, 16)
                                                                .lineLimit(2)
                                                        }
                                                    }
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 4)
                                                            .stroke(isChosenOption ? CustomColor.GrayScaleColor.black : CustomColor.GrayScaleColor.gs3, lineWidth: 1)
                                                    }
                                                    .onTapGesture {
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
                                                            .lineLimit(1)
                                                            .truncationMode(.tail)
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
                            isLottie = true
                            voteStore.searchInformation(categoryId: voteStore.currentVoteDetail.category.categoryId, voteId: voteStore.currentVoteDetail.voteId) { success in
                                if success {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                        withAnimation {
//                                            proxy.scrollTo("bottom")
//                                        }
                                        voteStore.updateUserVoteChoices(voteId: voteId, chosenVoteOptionIds: chosenVoteOptionId) { isSuccess in
                                            voteStore.fetchVoteDetail(voteId: voteId) {
                                                isLottie = false
                                                isVoted = true
                                            }
                                        }
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
                    .disabled(voteStore.currentVoteDetail.isMultipleChoiceAllowed ? chosenVoteOptionId.isEmpty : chosenVoteIndex == nil)
//                    .disabled(chosenVoteOptionId.isEmpty || chosenVoteIndex == nil)
                }
            } //: Vstack
            .showToastView(toast: $toast)
            .opacity(isLottie ? 0 : 1)
            .redacted(reason: isLoading ? .placeholder : [])
        } //: Zstack
        .onAppear {
            Task {
                voteStore.fetchVoteDetail(voteId: voteId) {
                    isLoading = false
                }
            }
        }
    }
}

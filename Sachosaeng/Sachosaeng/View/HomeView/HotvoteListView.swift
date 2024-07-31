//
//  VoteCellView.swift
//  Sachosaeng
//
//  Created by LJh on 6/26/24.
//

import SwiftUI

struct HotvoteListView: View {
    var hotVote: HotVote
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                AsyncImage(url: URL(string: "\(hotVote.category.iconUrl)")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .padding(.trailing, 6)
                    case .failure(let error):
                        Text("Failed to load image: \(error.localizedDescription)")
                    @unknown default:
                        Text("Unknown image")
                    }
                }
                Text(hotVote.category.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(CustomColor.GrayScaleColor.gs6)
                Spacer()
            }
            .padding(.bottom, 12)
            ForEach(Array(zip(hotVote.votes.indices, hotVote.votes)), id: \.1) { index, vote in
                VoteCell(vote: vote, index: index + 1)
            }
        }
        .padding(.horizontal, 20)
    }
}

struct VoteCell: View {
    var vote: Vote
    var index: Int
    @State var iss: Bool = false
    var body: some View {
        Button {
            iss.toggle()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 60)
                    .foregroundStyle(CustomColor.GrayScaleColor.white)
                
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 0) {
                            Text("\(index)  \(vote.title)")
                                .font(.createFont(weight: .bold, size: 15))
                                .foregroundStyle(CustomColor.GrayScaleColor.black)
                                .lineLimit(1)
                            Spacer()
                        }
                       
                        HStack(spacing: 0) {
                            Text("\(vote.participantCount ?? 0)명 참여 중")
                                .font(.createFont(weight: .medium, size: 12))
                                .foregroundStyle(CustomColor.GrayScaleColor.gs6)
                        }
                        .padding(.leading, 14)
                    }
                    .padding(.horizontal, 16)
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .frame(width: 32, height: 32)
                            .foregroundStyle(Color(hex: vote.category.backgroundColor))
                        AsyncImage(url: URL(string: vote.category.iconUrl)) { phase in
                            switch phase {
                            case .empty:
                                EmptyView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                            case .failure(let error):
                                Text("Failed to load image: \(error.localizedDescription)")
                            @unknown default:
                                Text("Unknown image")
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .frame(height: 60)
            .padding(.bottom, 6)
        }
        .buttonStyle(.plain)
        .navigationDestination(isPresented: $iss) {
            VoteView(vote: vote)
        }
    }
}


#Preview(body: {
    HotvoteListView(hotVote: dummyHotvote)
})

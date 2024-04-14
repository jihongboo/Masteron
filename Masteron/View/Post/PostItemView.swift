//
//  TimelineView.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.14.
//

import SwiftUI
import QuickLook

struct PostItemView: View {
    let post: Post
            
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                accountView
                Spacer()
                Text(post.createdAt, style: .time)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Text(post.content)
            MediasView(medias: post.mediaAttachments)
            tags
        }
    }
    
    private var accountView: some View {
        HStack {
            AsyncImage(url: post.account.avatar) { image in
                image
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } placeholder: {
                Color.gray
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
            Text(post.account.displayName)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .background(
            NavigationLink(value: post.account) {
                EmptyView()
                    .contentShape(Rectangle())
            }
                .opacity(0)
        )
    }
    
    private var tags: some View {
        HStack {
            Spacer()
            if post.repliesCount > 0 {
                tag(systemName: "arrowshape.turn.up.left", count: post.repliesCount)
            }
            
            if post.reblogsCount > 0 {
                tag(systemName: (post.reblogged ? "arrow.left.arrow.right.square.fill" : "arrow.left.arrow.right.square"), count: post.reblogsCount)
            }
            
            if post.favouritesCount > 0 {
                tag(systemName: (post.favourited ? "star.fill" : "star"), count: post.favouritesCount)
            }
            
            if post.bookmarked {
                Image(systemName: "bookmark.fill")
            }
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
    }
    
    @ViewBuilder
    private func tag(systemName: String, count: Int) -> some View {
        HStack(spacing: 2) {
            Image(systemName: systemName)
            Text(count, format: .number)
        }
    }
}

#Preview("Images") {
    NavigationStack {
        List {
            PostItemView(post: model())
        }
        .listStyle(.plain)
    }
}

#Preview("Video") {
    NavigationStack {
//        List {
            PostItemView(post: model("Post(Video)"))
//        }
//        .listStyle(.plain)
    }
}

//
//  PostDetailView.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.15.
//

import SwiftUI

struct PostView: View {
    @State var post: Post
    @State private var comments: [Post]? = nil
    @State private var error: Error? = nil

    var body: some View {
        List {
            PostItemView(post: post)
            Section("Comments") {
                if let comments {
                    ForEach(comments) { comment in
                        PostItemView(post: comment)
                            .contextMenu { contextMenu(comment: comment) }
                    }
                } else {
                    indicator
                }
            }
        }
        .listStyle(.plain)
        .refreshable {
            await load()
        }
        .onError(error, retry: {
            await load()
        })
        .oneTask {
            await load()
        }
        .navigationTitle("Posts")
        .toolbar { toolbar }
    }
    
    private var indicator: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
    
    @ViewBuilder
    private func contextMenu(comment: Post) -> some View {
        Group {
            ControlGroup {
                Button("Comment", systemImage: "arrowshape.turn.up.left") {
                    
                }
                Button("Boost", systemImage: "arrow.left.arrow.right") {
                    
                }
                Button("Star", systemImage: "star") {
                    
                }
                Button("Bookmark", systemImage: "bookmark") {
                    
                }
            }
            .controlGroupStyle(.compactMenu)
            ShareLink(item: comment.url) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        }
    }
    
#if os(iOS)
    let placement = ToolbarItemPlacement.bottomBar
#else
    let placement = ToolbarItemPlacement.automatic
#endif
    
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItemGroup(placement: placement) {
            Button("Comment", systemImage: "arrowshape.turn.up.left") {
                
            }
            Spacer()
            Button("Bookmark", systemImage: "bookmark") {
                
            }
            Spacer()
            Button("Boost", systemImage: "arrow.left.arrow.right") {
                
            }
            Spacer()
            Button("Star", systemImage: "star") {
                
            }
            Spacer()
            
            Menu("More", systemImage: "ellipsis") {
                ShareLink(item: post.url) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
        }
    }
    
    private func load() async {
        async let asyncPost = loadPost()
        async let asyncComments = loadComments()
        do {
            let (post, comments) = try await (asyncPost, asyncComments)
            self.post = post
            self.comments = comments
        } catch {
            self.error = error
            Log.app.error("\(error)")
        }
    }
    
    private func loadPost() async throws -> Post {
        return try await API.mastodon.request(method: .get, path: "/statuses/\(post.id)")
    }
    
    private func loadComments() async throws -> [Post] {
        struct Response: Decodable {
            let descendants: [Post]
        }
        
        let response: Response = try await API.mastodon.request(method: .get, path: "/statuses/\(post.id)/context")
        return response.descendants
    }
}

#Preview {
    NavigationStack {
        PostView(post: model())
    }
}

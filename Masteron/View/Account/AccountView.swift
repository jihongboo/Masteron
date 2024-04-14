//
//  AccountView.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.15.
//

import SwiftUI

struct AccountView: View {
    @State var account: Account
    @State private var posts: [Post] = []
    @State private var selection = AccountPostsType.posts
    
    var body: some View {
        List {
            AccountInfoView(account: account)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)

            Group {
                Picker("Segments", selection: $selection) {
                    ForEach(AccountPostsType.allCases) { type in
                        Label(type.title, systemImage: type.icon)
                    }
                }
                .labelsHidden()
                .pickerStyle(.segmented)
                .listRowSeparator(.hidden)
                .onChange(of: selection) { oldValue, newValue in
                    Task {
                        posts = []
                        await loadPosts()
                    }
                }
                
                ForEach(posts) { post in
                    NavigationLink(value: post) {
                        PostItemView(post: post)
                            .contextMenu { contextMenu(post: post) }
                    }
                }
            }
        }
        .listStyle(.plain)
        .ignoresSafeArea(.all, edges: .top)
        .refreshable {
            posts = []
            await loadAccount()
            await loadPosts()
        }
        .oneTask {
            await loadPosts()
        }
        .navigationTitle(account.displayName)
        .toolbar { toolbar }
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }
    
    @ViewBuilder
    private func contextMenu(post: Post) -> some View {
        Group {
            ControlGroup {
                Button("Comment", systemImage: "square.and.pencil") {
                    
                }
                Button("Boost", systemImage: "arrow.left.arrow.right") {
                    
                }
                Button("Star", systemImage: "star") {
                    
                }
                Button("Bookmark", systemImage: "bookmark") {
                    
                }
            }
            .controlGroupStyle(.compactMenu)
            ShareLink(item: post.url) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        }
    }
    
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItemGroup {
            Button("Comment", systemImage: "message") {
                
            }
        }
        ToolbarItem {
            Menu("More", systemImage: "ellipsis") {
                Button("Bookmark", systemImage: "bookmark") {
                    
                }
                Button("Follow", systemImage: "heart") {
                    
                }
                ShareLink(item: account.url) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
        }
    }
}

private enum AccountPostsType: CaseIterable, Identifiable {
    var id: AccountPostsType { self }
    
    case posts
    case replies
    case medias
    
    var title: String {
        switch self {
        case .posts:
            "Posts"
        case .replies:
            "Replies"
        case .medias:
            "Medias"
        }
    }
    
    var icon: String {
        switch self {
        case .posts:
            "list.bullet"
        case .replies:
            "message"
        case .medias:
            "photo.fill"
        }
    }
}

#Preview {
    NavigationStack {
        AccountView(account: model())
    }
}
extension AccountView {
    private func loadAccount() async {
        do {
            account = try await API.mastodon.request(method: .get, path: "/accounts/\(account.id)")
        } catch {
            Log.app.error("\(error)")
        }
    }
    
    private func loadPosts() async {
        let parameters: [String: AnyHashable]
        switch selection {
        case .posts:
            parameters = ["exclude_replies": true]
        case .replies:
            parameters = ["exclude_replies": false]
        case .medias:
            parameters = ["only_media": true]
        }
        if selection == .posts {
        }
        
        do {
            let newPosts: [Post] = try await API.mastodon.request(method: .get, 
                                                                  path: "/accounts/\(account.id)/statuses",
                                                                  parameters: parameters)
            posts.append(contentsOf: newPosts)
        } catch {
            Log.app.error("\(error)")
        }
    }
}

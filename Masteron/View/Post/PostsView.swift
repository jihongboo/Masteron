//
//  TimelinesView.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.15.
//

import SwiftUI

struct PostsView: View {
    @AppStorage("PostsType") private var type: PostsType = .home
    @State private var posts: [Post] = []
    @State private var isLoading: Bool = false
    @State private var error: Error? = nil
    
    var body: some View {
        List(posts) { post in
            NavigationLink(value: post) {
                PostItemView(post: post)
                    .task {
                        if post == posts.last && !isLoading {
                            await load()
                        }
                    }
            }
        }
        .listStyle(.plain)
        .refreshable {
            await reload()
        }
        .onError(error, retry: {
            await reload()
        })
        .oneTask {
            await reload()
        }
        .toolbar { toolbar }
        .navigationTitle(type.title)
    }
    
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem {
            Menu("List", systemImage: "list.bullet") {
                ForEach(PostsType.allCases) { type in
                    Button(type.title, systemImage: type.systemImage) {
                        Task {
                            self.type = type
                            await reload()
                        }
                    }
                }
            }
        }
        ToolbarItemGroup {
            Button("Comment", systemImage: "square.and.pencil") {
                
            }
        }
    }
    
    private func reload() async {
        posts = []
        await load()
    }
    
    private func load() async {
        isLoading = true
        defer {
            isLoading = false
        }
        self.error = nil
        do {
            let newPosts: [Post]
            var parameters = [String: AnyHashable]()
            switch type {
            case .home:
                newPosts = try await API.mastodon.request(method: .get, path: "/timelines/home")
            case .local:
                if let last = posts.last {
                    parameters["max_id"] = last.id
                }
                parameters["local"] = true
                newPosts = try await API.mastodon.request(method: .get, path: "/timelines/public", parameters: parameters)
            case .federated:
                if let last = posts.last {
                    parameters["max_id"] = last.id
                }
                parameters["local"] = false
                newPosts = try await API.mastodon.request(method: .get, path: "/timelines/public", parameters: parameters)
            case .trending:
                if !posts.isEmpty {
                    parameters["offset"] = posts.count

                }
                newPosts = try await API.mastodon.request(method: .get, path: "/trends/statuses", parameters: parameters)
            }
            
            posts.append(contentsOf: newPosts)
            if posts.isEmpty {
                self.error = CommonContentUnavailable.empty
            }
        } catch {
            self.error = error
            Log.app.error("\(error)")
        }
    }
}

private extension PostsView {
    init(posts: [Post]) {
        _posts = .init(initialValue: posts)
    }
}

private enum PostsType: String, CaseIterable, Identifiable {
    var id: PostsType { self }
    
    case home
    case local
    case federated
    case trending
    
    var title: LocalizedStringKey {
        switch self {
        case .home:
            "Home"
        case .local:
            "Local"
        case .federated:
            "Federated"
        case .trending:
            "Trending"
        }
    }
    
    var systemImage: String {
        switch self {
        case .home:
            "house"
        case .local:
            "location"
        case .federated:
            "globe"
        case .trending:
            "chart.line.uptrend.xyaxis"
        }
    }
}

#Preview("Local") {
    NavigationStack {
        PostsView(posts: model())
    }
}

#Preview("Remote") {
    NavigationStack {
        PostsView()
    }
}

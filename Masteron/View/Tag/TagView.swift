//
//  TagView.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.15.
//

import SwiftUI
import Charts

struct TagView: View {
    let tag: Tag
    @State private var posts: [Post] = []
    @State private var error: Error? = nil
    @State private var isLoading: Bool = false
    
    var body: some View {
        List {
            Section("Trending") {
                trending
            }
            Section("Posts") {
                ForEach(posts) { post in
                    NavigationLink(value: post) {
                        PostItemView(post: post)
                    }
                    .task {
                        if post == posts.last && !isLoading {
                            await load()
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .refreshable {
            await reload()
        }
        .oneTask {
            await reload()
        }
        .oneTask {
            await reload()
        }
        .toolbar {
            ToolbarItemGroup {
                Button("Add", systemImage: "plus.circle") {
                    
                }
            }
        }
        .navigationTitle(tag.name)
    }
    
    private var trending: some View {
        VStack(alignment: .leading) {
            Text("Total Uses")
                .font(.callout)
                .foregroundStyle(.secondary)
            Text(tag.totalAccounts, format: .number)
                .font(.title2.bold())
                .foregroundColor(.primary)
            Text("by \(tag.totalAccounts) users")
                .font(.callout)
                .foregroundStyle(.secondary)
            Chart(tag.history) { history in
                AreaMark(
                    x: .value("Day", history.day),
                    y: .value("Uses", history.uses)
                )
                .interpolationMethod(.monotone)
                .foregroundStyle(Gradient(colors: [.accentColor, .clear]))
                LineMark(
                    x: .value("Day", history.day),
                    y: .value("Uses", history.uses)
                )
                .interpolationMethod(.monotone)
            }
            .frame(height: 160)
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
        error = nil
        
        var parameters = [String: AnyHashable]()
        if let last = posts.last {
            parameters["max_id"] = last.id
        }
        do {
            let newPosts: [Post] = try await API.mastodon.request(method: .get, 
                                                                  path: "/timelines/tag/\(tag.name)",
                                                                  parameters: parameters)
            posts.append(contentsOf: newPosts)
        } catch {
            self.error = error
            Log.app.error("\(error)")
        }
    }
}

#Preview {
    NavigationStack {
        TagView(tag: model())
    }
}

//
//  TagsView.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.15.
//

import SwiftUI

struct TagsView: View {
    @State var tags: [Tag]
    @State private var error: Error? = nil
    @State private var isLoading: Bool = false

    var body: some View {
        List(tags) { tag in
            TagItemView(tag: tag)
                .task {
                    if tag == tags.last && !isLoading {
                        await load()
                    }
                }
        }
        .refreshable {
            await reload()
        }
        .onError(error, retry: {
            await reload()
        })
        .oneTask {
            await load()
        }
        .navigationTitle("Tags")
    }
    
    private func reload() async {
        tags = []
        await load()
    }
    
    private func load() async {
        isLoading = true
        defer {
            isLoading = false
        }
        self.error = nil
        
        do {
            let newTags: [Tag] = try await loadTags()
            tags.append(contentsOf: newTags)
        } catch {
            self.error = error
            Log.app.error("\(error)")
        }
    }
    
    private func loadTags() async throws -> [Tag] {
        let parameters = tags.isEmpty ? nil : ["offset": tags.count]
        return try await API.mastodon.request(method: .get, path: "/trends/tags", parameters: parameters)
    }
}

#Preview{
    NavigationStack {
        TagsView(tags: model())
    }
}

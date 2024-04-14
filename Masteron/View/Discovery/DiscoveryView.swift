//
//  DiscoveryView.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.16.
//

import SwiftUI

struct DiscoveryView: View {
    @State private var tags: [Tag] = []
    @State private var accounts: [Account] = []
    @State private var searchText: String = ""
    @State private var error: Error? = nil
    
    var body: some View {
        List {
            if !tags.isEmpty {
                CommonListSection("Hashtags") {
                    ForEach(tags[0 ... 5]) { tag in
                        TagItemView(tag: tag)
                    }
                }
            }
            if !accounts.isEmpty {
                CommonListSection("People") {
                    ForEach(accounts[0 ... 5]) { account in
                        AccountItemView(account: account)
                    }
                }
            }
        }
        .refreshable {
            await load()
        }
        .searchable(text: $searchText)
        .onError(error, retry: {
            await load()
        })
        .task {
            await load()
        }
        .navigationTitle("Discovery")
    }
    
    private func load() async {
        async let asyncTags: [Tag] = API.mastodon.request(method: .get, path: "/trends/tags")
        async let asyncAccounts: [Account] = API.mastodon.request(method: .get, path: "/suggestions")
        do {
            let (tags, accounts) = try await (asyncTags, asyncAccounts)
            self.tags = tags
            self.accounts = accounts
        } catch {
            self.error = error
            Log.app.error("\(error)")
        }
    }
}

#Preview {
    NavigationStack {
        DiscoveryView()
    }
}

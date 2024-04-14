//
//  CommonNavigationStack.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.16.
//

import SwiftUI

struct CommonNavigationStack<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        NavigationStack {
            content
                .navigationDestination(for: Account.self) { account in
                    AccountView(account: account)
                }
                .navigationDestination(for: Post.self) { post in
                    PostView(post: post)
                }
                .navigationDestination(for: Tag.self) { tag in
                    TagView(tag: tag)
                }
        }
    }
}

#Preview {
    CommonNavigationStack {
        EmptyView()
    }
}

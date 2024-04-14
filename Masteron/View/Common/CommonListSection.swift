//
//  CommonListSection.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.16.
//

import SwiftUI

struct CommonListSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        Section {
            content
        } header: {
            HStack {
                Text(title)
                Spacer()
                seeMore
            }
        }
    }
    
    var seeMore: some View {
        NavigationLink(value: "") {
            HStack {
                Text("See More")
                Image(systemName: "chevron.forward")
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CommonListSection("Title") {
        EmptyView()
    }
}

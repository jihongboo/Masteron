//
//  TabHome.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.16.
//

import SwiftUI

struct TabHome: View {
    var body: some View {
        TabView {
            ForEach(Tab.allCases) { tab in
                
            }
            PostsView()
        }
    }
}

#Preview {
    TabHome()
}

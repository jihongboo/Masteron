//
//  ContentView.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.14.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var tab: Tab? = .timelines
    
    var body: some View {
#if os(iOS)
        tabView
#else
        navigationSplit
#endif
    }
    
    var tabView: some View {
        TabView {
            ForEach(Tab.allCases) { tab in
                CommonNavigationStack {
                    tab.view()
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.systemImage)
                }
            }
        }
    }
    
    var navigationSplit: some View {
        NavigationSplitView {
            List(Tab.allCases, selection: $tab) { tab in
                Label(tab.title, systemImage: tab.systemImage)
            }
        } detail: {
            CommonNavigationStack {
                tab?.view()
            }
        }
    }
}

#Preview {
    ContentView()
}

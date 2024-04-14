//
//  Tab.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.16.
//

import SwiftUI

enum Tab: CaseIterable, Identifiable {
    case timelines
    case discovery
    case profile
    
    var id: Tab { self }
    
    var title: LocalizedStringKey {
        switch self {
        case .timelines:
            "Timeline"
        case .discovery:
            "Discovery"
        case .profile:
            "Profile"
        }
    }
    
    var systemImage: String {
        switch self {
        case .timelines:
            "rectangle.stack.fill"
        case .discovery:
            "safari.fill"
        case .profile:
            "person"
        }
    }
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .timelines:
            PostsView()
        case .discovery:
            DiscoveryView()
        case .profile:
            ProfileView()
        }
    }
}

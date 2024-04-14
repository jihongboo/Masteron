//
//  MasteronApp.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.14.
//

import SwiftUI
import SwiftData

@main
struct MasteronApp: App {
    var body: some Scene {
        WindowGroup {
            InstanceView(instance: model(), showLoginButton: true)
//            ContentView()
//                .task {
//                    UserDefaults.standard.register(defaults: ["MastodonHost": "mastodon.social"])
//                }
        }
    }
}

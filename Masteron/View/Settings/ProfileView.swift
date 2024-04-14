//
//  SettingsView.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.21.
//

import SwiftUI

struct ProfileView: View {
    @State private var instance: Instance?
    @State private var account: Account?
    @State private var isLoginPagePresented = false
    @AppStorage("MastodonHost") private var server: String?

    var body: some View {
        Form {
            Section("Server") {
                if let instance {
                    InstanceItemView(instance: instance)
                        .overlay {
                            NavigationLink(value: instance) {
                                Color.clear
                            }
                            .opacity(0.0)
                        }
                }
            }
            .task {
                if let server {
                    do {
                        instance = try await getInstance(name: server)
                    } catch {
                        
                    }
                }
            }
            
            Section("Account") {
                if let account {
                    AccountItemView(account: account)
                    NavigationLink(value: "") {
                        Label("Messages", systemImage: "at")
                    }
                    NavigationLink(value: "") {
                        Label("Favorites", systemImage: "heart")
                    }
                    NavigationLink(value: "") {
                        Label("Bookmarks", systemImage: "bookmark")
                    }
                    NavigationLink(value: "") {
                        Label("Followed Hashtags", systemImage: "number")
                    }
                    Button("Log Out", role: .cancel) {
                        
                    }
                    .foregroundStyle(.red)
                } else {
                    Button("Login") {
                        isLoginPagePresented = true
                    }
                }
            }
            
            Section("General") {
#if !os(macOS)
                Link("Settings", destination: URL(string: UIApplication.openSettingsURLString)!)
#endif
            }
        }
        .navigationTitle("Profile")
        .navigationDestination(for: Instance.self) { instance in
            InstanceView(instance: instance, showLoginButton: false)
        }
        .sheet(isPresented: $isLoginPagePresented, content: {
            LoginView()
        })
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .task {
                UserDefaults.standard.register(defaults: ["MastodonHost": "mastodon.social"])
            }
    }
}

private extension ProfileView {
    func getInstance(name: String) async throws -> Instance {
        if isPreview {
            return model()
        }
        return try await API.instances.request(method: .get,
                                               path: "/show",
                                               parameters: ["name": name])
    }
}

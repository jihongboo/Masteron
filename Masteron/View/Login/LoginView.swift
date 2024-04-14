//
//  LoginView.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.20.
//

import SwiftUI

struct LoginView: View {
    @State private var instances: [Instance] = []
    @State private var searchText: String = ""
    @State private var error: Error? = nil
    
    var body: some View {
        NavigationStack {
            Page {
                List {
                    ForEach(instances) { instance in
                        InstanceItemView(instance: instance)
                            .overlay {
                                NavigationLink(value: instance) {
                                    Color.clear
                                }
                                .opacity(0.0)
                            }
                            .oneTask {
                                if instance == instances.last {
                                    instances.append(contentsOf: await loadInstances())
                                }
                            }
                    }
                }
                .refreshable {
                    instances = await loadInstances()
                }
                .listRowSpacing(16)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
                .onSubmit(of: .search) {
                    if searchText.isEmpty { return }
                    Task {
                        instances = []
                        async let instance = getInstance(name: searchText)
                        async let searchResult = searchInstances(searchText: searchText)
                        instances = await instance + searchResult
                    }
                }
                .onChange(of: searchText, { _, newValue in
                    if newValue.isEmpty {
                        Task {
                            instances = await loadInstances()
                        }
                    }
                })
            } task: {
                instances = await loadInstances()
            }
            .navigationTitle("Servers")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Instance.self) { instance in
                InstanceView(instance: instance, showLoginButton: true)
            }
        }
    }
}

#Preview {
    LoginView()
}

private extension LoginView {
    static let authorization = "Bearer 4T8I27w8jcwXmtCHnYm0GTC4pHorR7jfhV1eCefgVRnlZYDkibqCEYZU31kRAYbakCGFG1Ii2x2xd8kdmCi45b0Wf55i7ArYHzpfsu8kQzdm1af3oXUDIiwM2hiJQJl3"
    
    func loadInstances() async -> [Instance] {
        struct Response: Decodable {
            let instances: [Instance]
        }
        if isPreview {
            return model()
        }
        do {
            let response: Response = try await API.instances.request(method: .get,
                                                                     path: "/list",
                                                                     parameters: ["include_closed" : false, "min_active_users": 500])
            return response.instances
        } catch {
            self.error = error
            Log.app.error("\(error)")
            return []
        }
    }
    
    func getInstance(name: String) async -> [Instance] {
        if isPreview {
            return model()
        }
        do {
            let instance: Instance = try await API.instances.request(method: .get,
                                                                     path: "/show",
                                                                     parameters: ["name": name])
            return [instance]
        } catch {
            return []
        }
    }
    
    func searchInstances(searchText: String) async -> [Instance] {
        struct Response: Decodable {
            let instances: [Instance]
        }
        if isPreview {
            return model()
        }
        do {
            let response: Response = try await API.instances.request(method: .get,
                                                                     path: "/search",
                                                                     parameters: ["q": searchText])
            return response.instances
        } catch {
            self.error = error
            Log.app.error("\(error)")
            return []
        }
    }
}

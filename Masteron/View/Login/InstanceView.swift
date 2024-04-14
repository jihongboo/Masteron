//
//  InstanceView.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.23.
//

import SwiftUI
import AuthenticationServices

struct InstanceView: View {
    let instance: Instance
    let showLoginButton: Bool

    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    @Environment(\.dismiss) private var dismiss
    @AppStorage("Authorization") private var authorization: String?
    @State private var showFullDescription = false
    @State private var error: Error? = nil

    var body: some View {
        Form {
            Section("General") {
                thumbnail
                    .listRowInsets(EdgeInsets())
                LabeledContent("ID", value: instance.id)
                LabeledContent("Name", value: instance.name)
                LabeledContent("Users") {
                    Text(instance.users, format: .number)
                }
                LabeledContent("Statuses") {
                    Text(instance.statuses, format: .number)
                }
            }
            if let shortDescription = instance.info.shortDescription {
                Section("Description") {
                    Text(shortDescription)
                    if let fullDescription = instance.info.fullDescription {
                        Button(action: {
                            showFullDescription = true
                        }, label: {
                            Text(fullDescription)
                                .lineLimit(4)
                        })
                        .buttonStyle(.plain)
                    }
                }
            }
            
            Section("Information") {
                LabeledContent("Updated") {
                    Text(instance.updatedAt, format: .dateTime)
                }
                ItemView(title: "Dead", image: "checkmark.circle", enabled: instance.dead)
                ItemView(title: "Open Registrations", image: "checkmark.circle", enabled: instance.openRegistrations)
                ItemView(title: "Topic", value: instance.info.topic)
                ItemView(title: "languages", value: instance.info.languages.joined())
                ItemView(title: "Other Languages Accepted", image: "checkmark.circle", enabled: instance.info.otherLanguagesAccepted)
                ItemView(title: "prohibitedContent", value: instance.info.prohibitedContent.joined())
                ItemView(title: "Categories", value: instance.info.categories.joined())

            }
            
            Section("Technique") {
                ItemView(title: "Version", value: instance.version)
                ItemView(title: "ipv6", image: "checkmark.circle", enabled: instance.ipv6)
                ItemView(title: "Https Score", value: instance.httpsScore)
                ItemView(title: "Https Rank", value: instance.httpsRank)
                ItemView(title: "OBS Score", value: instance.obsScore)
                ItemView(title: "OBS Score", value: instance.obsRank)
                ItemView(title: "OBS Rank", value: instance.obsRank)
            }
            
            Section("Contact") {
                ItemView(title: "Admin", value: instance.admin)
                Link(destination: instance.email, label: {
                    ItemView(title: "Email", value: instance.email.absoluteString)
                })
            }
        }
        .sheet(isPresented: $showFullDescription, content: {
            NavigationStack {
                WebView(HTMLString: instance.info.fullDescription ?? "")
                    .ignoresSafeArea()
                    .navigationTitle("Full Description")
#if !os(macOS)
                    .navigationBarTitleDisplayMode(.inline)
#endif
                    .toolbar {
                        ToolbarItem {
                            Button("Done") {
                                showFullDescription = false
                            }
                        }
                    }
            }
        })
        .toolbar {
            ToolbarItem {
                if showLoginButton {
                    Button("Login") {
                        Task {
                            await login()
                        }
                    }
                }
            }
        }
        .navigationTitle(instance.name)
    }
    
    var thumbnail: some View {
        GeometryReader(content: { geometry in
            AsyncImage(url: instance.thumbnail) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: 120)
            } placeholder: {
                Color.gray
                    .frame(height: 120)
            }
            .clipped()
        })
        .frame(height: 120)
    }
    
    private struct ItemView: View {
        let title: String
        let value: String?
        let image: String?
        let enabled: Bool
        
        init(title: String, value: String?) {
            self.title = title
            self.value = value ?? "Unknown"
            self.image = nil
            self.enabled = false
        }
        
        init(title: String, value: Int?) {
            self.title = title
            if let value {
                self.value = "\(value)"
            } else {
                self.value = "Unknown"
            }
            self.image = nil
            self.enabled = false
        }
        
        init(title: String, image: String, enabled: Bool) {
            self.title = title
            self.image = image
            self.value = nil
            self.enabled = enabled
        }
        
        var body: some View {
            if let value {
                LabeledContent(title, value: value)
            } else if let image {
                LabeledContent(title) {
                    Image(systemName: image)
                        .foregroundStyle(enabled ? .green : .secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        InstanceView(instance: model(), showLoginButton: true)
    }
}

private extension InstanceView {
    struct RegisterAppResponse: Decodable {
        let id: String
        let name: String
        let scopes: [String]
        let redirectUri: String
        let clientId: String
        let clientSecret: String
        let vapidKey: String
        let website: String?
    }
    
    func login() async {
        do {
            let registerAppResponse = try await registerApp()
            let code = try await authorize(server: instance.name,
                                           clientID: registerAppResponse.clientId,
                                           scopes: registerAppResponse.scopes,
                                           redirectURI: registerAppResponse.redirectUri)
            authorization = try await requestAccessToken(clientId: registerAppResponse.clientId,
                                                         clientSecret: registerAppResponse.clientSecret,
                                                         code: code,
                                                         redirectURI: registerAppResponse.redirectUri,
                                                         scopes: registerAppResponse.scopes)
            let result = try await verifyCredentials(registerAppResponse: registerAppResponse)
            if result {
                dismiss()
            } else {
                error = CommonError.message("verify failed")
            }
        } catch {
            self.error = error
            Log.app.error("\(error)")
        }
    }
    
    func registerApp() async throws -> RegisterAppResponse {
        struct Parameters: Encodable {
            let scopes: String
            let redirectUris: String
            let clientName: String
            let website: String
        }
        
        let parameters = ["scopes": "read write follow push",
                          "redirect_uris": "masteron://oauth",
                          "client_name": "Masteron",
                          "website": ""]
        
        return try await API.mastodon.request(method: .post, path: "/apps", parameters: parameters)
    }
    
    func authorize(server: String,
                   clientID: String,
                   scopes: [String],
                   redirectURI: String) async throws -> String {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = server
        urlComponents.path = "/oauth/authorize"
        urlComponents.queryItems = [URLQueryItem(name: "client_id", value: clientID),
                                    URLQueryItem(name: "scope", value: scopes.joined(separator: "+")),
                                    URLQueryItem(name: "redirect_uri", value: redirectURI),
                                    URLQueryItem(name: "response_type", value: "code")]
        let responseURL = try await webAuthenticationSession.authenticate(
            using: urlComponents.url!,
            callbackURLScheme: "masteron"
        )
        let responseURLComponents = URLComponents(url: responseURL, resolvingAgainstBaseURL: true)
        let code = responseURLComponents?.queryItems?.first(where: { $0.name == "code" })?.value
        if let code {
            return code
        } else {
            throw CommonError.message("No Code")
        }
    }
    
    func requestAccessToken(clientId: String,
                            clientSecret: String,
                            code: String,
                            redirectURI: String,
                            scopes: [String]) async throws -> String {
        struct Response: Decodable {
            let tokenType: String
            let accessToken: String
        }
        
        let parameters = ["client_id": clientId,
                          "client_secret": clientSecret,
                          "code": code,
                          "grant_type": "authorization_code",
                          "redirect_uri": redirectURI,
                          "scope": scopes.joined(separator: "+")]
        let response: Response = try await API.mastodonOAuth.request(method: .post, path: "", parameters: parameters)
        return "\(response.tokenType) \(response.accessToken)"
    }
    
    func verifyCredentials(registerAppResponse: RegisterAppResponse) async throws -> Bool {
        struct Response: Decodable {
            let clientId: String
            let name: String
            let scopes: [String]
            let vapidKey: String
            let website: String?
        }
        
        let response: Response = try await API.mastodon.request(method: .get, path: "/apps/verify_credentials")
        
        return registerAppResponse.clientId == response.clientId &&
        registerAppResponse.name == response.name &&
        registerAppResponse.scopes == response.scopes &&
        registerAppResponse.vapidKey == response.vapidKey &&
        registerAppResponse.website == response.website
    }
}

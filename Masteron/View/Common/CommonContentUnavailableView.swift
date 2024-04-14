//
//  CommonContentUnavailableView.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.20.
//

import SwiftUI

struct CommonContentUnavailableView: View {
    let error: Error
    let retry: () async -> Void
    
    @State private var isLoginPagePresented = false
    
    var body: some View {
        ContentUnavailableView {
            Label((error as? ContentUnavailable)?.title ?? "Error", 
                  systemImage: (error as? ContentUnavailable)?.icon ?? "xmark.bin")
        } description: {
            Text((error as? ContentUnavailable)?.description ?? error.localizedDescription)
        } actions: {
            Button((error as? ContentUnavailable)?.buttonTitle ?? "Retry") {
                runTask()
            }
            .buttonStyle(.borderedProminent)
        }
        .background(.background)
        .sheet(isPresented: $isLoginPagePresented, content: {
            LoginView()
        })
        .onChange(of: isLoginPagePresented) { oldValue, newValue in
            if oldValue == true && newValue == false {
                Task {
                    await retry()
                }
            }
        }
    }
    
    private func runTask() {
        Task {
            if let error = error as? HTTPError,
                error == .authentication {
                isLoginPagePresented = true
            } else {
                await retry()
            }
        }
    }
}

#Preview {
    CommonContentUnavailableView(error: CommonContentUnavailable.empty, retry: {})
}

struct ContentUnavailableModifier: ViewModifier {
    let error: Error?
    let retry: () async -> Void

    func body(content: Content) -> some View {
        ZStack {
            content
            if let error {
                CommonContentUnavailableView(error: error, retry: retry)
            }
        }
    }
}

extension View {
    func onError(_ error: Error?, retry: @escaping () async -> Void) -> some View {
        self.modifier(ContentUnavailableModifier(error: error, retry: retry))
    }
}

protocol ContentUnavailable {
    var icon: String? { get }
    var title: String? { get }
    var description: String? { get }
    var buttonTitle: String? { get }
}

extension ContentUnavailable {
    var icon: String? { nil }
    var title: String? { nil }
    var description: String? { nil }
    var buttonTitle: String? { nil }
}

enum CommonContentUnavailable: Error, ContentUnavailable {
    case empty
    
    var title: String? { "No Content" }
    var icon: String? { "tray" }
    var description: String? { NSLocalizedString("Please click the Retry button.", comment: "") }
}

//
//  ContentUnavailableView.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.18.
//

import SwiftUI

struct Page<Content: View>: View {
    private let content: Content
    private let task: () async throws -> Void
    @State private var state: PageState = .initialize
    
    init(@ViewBuilder content: () -> Content,
         task: @escaping () async throws -> Void) {
        self.content = content()
        self.task = task
    }
    
    var body: some View {
        ZStack {
            switch state {
            case .initialize:
                EmptyView()
            case .loading:
                ProgressView()
                    .background(.background)
            case .success:
                content
                    .refreshable {
                        await runTask()
                    }
            case .fail(let error):
                CommonContentUnavailableView(error: error) {
                    await runTask()
                }
            }
        }
        .task {
            if state == .initialize {
                await runTask()
            }
        }
    }
    
    private func runTask() async {
        Task {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            if state == .initialize {
                state = .loading
            }
        }
        do {
            try await task()
            state = .success
        } catch {
            state = .fail(error: error)
            Log.app.error("\(error)")
        }
    }
}

private enum PageState: Equatable {
    static func == (lhs: PageState, rhs: PageState) -> Bool {
        switch (lhs, rhs) {
        case (.initialize, .initialize): true
        case (.loading, .loading): true
        case (.success, .success): true
        case (.fail(let lhsValue), .fail(let rhsValue)): type(of: lhsValue) == type(of: rhsValue)
        default: false
        }
    }
    
    case initialize
    case loading
    case success
    case fail(error: Error)
}

#Preview {
    Page {
        Text("Text")
    } task: {
    }
}

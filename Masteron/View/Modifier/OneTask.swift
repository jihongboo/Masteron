//
//  OneTask.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.20.
//

import SwiftUI

struct OneTaskModifier: ViewModifier {
    let action: (() async -> Void)
    @State private var didLoad = false
    
    func body(content: Content) -> some View {
        content
            .task {
                if didLoad == false {
                    didLoad = true
                    await action()
                }
            }
    }
}

extension View {
    func oneTask(perform action: @escaping (() async -> Void)) -> some View {
        self.modifier(OneTaskModifier(action: action))
    }
}

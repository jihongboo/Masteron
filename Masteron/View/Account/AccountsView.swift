//
//  AccountsView.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.16.
//

import SwiftUI

struct AccountsView: View {
    let accounts: [Account] = model()
    
    var body: some View {
        List(accounts) { account in
            AccountItemView(account: account)
        }
        .navigationTitle("Suggested Users")
    }
}

#Preview {
    NavigationStack {
        AccountsView()
    }
}

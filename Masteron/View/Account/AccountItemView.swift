//
//  AccountCell.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.16.
//

import SwiftUI

struct AccountItemView: View {
    let account: Account
    
    var body: some View {
        NavigationLink(value: account) {
            HStack {
                AsyncImage(url: account.avatar) { image in
                    image
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } placeholder: {
                    Color.gray
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                VStack(alignment: .leading) {
                    Text(account.displayName)
                    Text(account.acct)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        List {
            AccountItemView(account: model())
        }
    }
}

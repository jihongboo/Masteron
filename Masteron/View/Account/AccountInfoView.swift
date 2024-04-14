//
//  AccountInfoView.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.20.
//

import SwiftUI

struct AccountInfoView: View {
    let account: Account
    
    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader(content: { geometry in
                AsyncImage(url: account.header) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.width / 2)
                } placeholder: {
                    Color.gray
                        .aspectRatio(2, contentMode: .fit)
                }
            })
            .aspectRatio(2, contentMode: .fit)
            .clipped()
            VStack(alignment: .leading) {
                HStack {
                    avatarAndName
                    Spacer()
                    datas
                }
                Text(account.note)
            }
            .padding()
        }
    }
    
    var avatarAndName: some View {
        ViewThatFits {
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
                        .foregroundStyle(.secondary)
                }
            }
            VStack(alignment: .leading) {
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
                Text(account.displayName)
                Text(account.acct)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    var datas: some View {
        HStack {
            AccountDataView(title: "Posts", value: account.statusesCount)
            Divider()
            AccountDataView(title: "Following", value: account.followingCount)
            Divider()
            AccountDataView(title: "Followers", value: account.followersCount)
        }
    }
}

private struct AccountDataView: View {
    let title: String
    let value: Int
    
    var body: some View {
        VStack {
            Text(value, format: .number)
                .fontWeight(.bold)
            Text(title)
                .foregroundStyle(.secondary)
        }
        .font(.caption)
    }
}

#Preview {
    List {
        AccountInfoView(account: model())
            .listRowInsets(EdgeInsets())
    }
    .ignoresSafeArea()
    .listStyle(.plain)
}

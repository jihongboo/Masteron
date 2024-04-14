//
//  InstanceItemView.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.23.
//

import SwiftUI

struct InstanceItemView: View {
    let instance: Instance
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            thumbnail

            VStack(alignment: .leading) {
                Text(instance.name)
                    .font(.title3)
                    .fontWeight(.medium)
                Text(instance.info.shortDescription ?? "")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .listRowInsets(EdgeInsets())
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
}

#Preview {
    List {
        InstanceItemView(instance: model())
    }
}

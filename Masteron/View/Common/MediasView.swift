//
//  ImageViewer.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.17.
//

import SwiftUI
import AVKit

struct MediasView: View {
    let medias: [Media]
    @State private var selectedItem: URL?

    var body: some View {
        if let first = medias.first, first.type == .video {
            VideoPlayer(player: AVPlayer(url: first.url))
                .scaledToFit()
                .clipped()
        } else {
            Grid(horizontalSpacing: 4, verticalSpacing: 4) {
                GridRow {
                    ForEach(medias[0 ..< (medias.count < 3 ? medias.count : 3)]) { media in
                        mediaCell(media: media)
                    }
                }
                if medias.count > 3 {
                    GridRow {
                        ForEach(medias[0 ..< (medias.count < 6 ? medias.count : 6)]) { media in
                            mediaCell(media: media)
                        }
                    }
                }
                if medias.count > 6 {
                    GridRow {
                        ForEach(medias[0 ..< (medias.count <  9 ? medias.count : 9)]) { media in
                            mediaCell(media: media)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func mediaCell(media: Media) -> some View {
        Button(action: {
            selectedItem = media.url
        }, label: {
            if media.type == .image {
                AsyncImage(url: media.previewUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(media.meta.small.ratio, contentMode: .fit)
                } placeholder: {
                    Color.gray
                        .aspectRatio(media.meta.small.ratio, contentMode: .fit)
                }
            }
        })
        .quickLookPreview($selectedItem, in: medias.map({ $0.url }))
        .buttonStyle(.plain)
    }
}

#Preview {
    MediasView(medias: model())
}

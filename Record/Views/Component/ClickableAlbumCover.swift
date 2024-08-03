//
//  ClickableAlbumCover.swift
//  Record
//
//  Created by nomamac2 on 5/24/24.
//

import SwiftUI

struct ClickableAlbumCover: View {
    var album: Album
    var onTabGestureHander: (Album) -> Void
    var size: CGFloat

    var body: some View {
        AsyncImage(url: URL.documentsDirectory.appending(path: album.artwork.absoluteString)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            } else if phase.error != nil {
                Image("cover_placeholder")
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            } else {
                Color.gray
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTabGestureHander(self.album)
        }
    }
}

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

    var body: some View {
        AsyncImage(url: URL.documentsDirectory.appending(path: album.artwork.absoluteString)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .scaledToFit()
            } else if phase.error != nil {
                Color.red
            } else {
                Color.blue
            }
        }
        .onTapGesture {
            onTabGestureHander(self.album)
        }
    }
}

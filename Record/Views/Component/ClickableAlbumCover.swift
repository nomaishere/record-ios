//
//  ClickableAlbumCover.swift
//  Record
//
//  Created by nomamac2 on 5/24/24.
//

import SwiftUI

struct ClickableAlbumCover: View {
    var album: Album

    var body: some View {
        AsyncImage(url: album.artwork) { phase in
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
    }
}

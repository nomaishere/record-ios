//
//  AlbumGridList.swift
//  Record
//
//  Created by nomamac2 on 5/24/24.
//

import SwiftUI

struct AlbumGridList: View {
    let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    var albums: [Image]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(albums.indices, id:\.self) {value in
                    ClickableAlbumCover(cover: albums[value])
                }
            }
            .padding(.horizontal, 16.0)
        }
    }
}

#Preview {
    AlbumGridList(albums: [Image("mmtbs"), Image("mb"), Image("tpab"),Image("bomm") ])
}

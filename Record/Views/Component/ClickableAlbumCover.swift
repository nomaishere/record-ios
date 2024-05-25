//
//  ClickableAlbumCover.swift
//  Record
//
//  Created by nomamac2 on 5/24/24.
//

import SwiftUI

struct ClickableAlbumCover: View {
    var cover: Image
    
    var body: some View {
        cover
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .scaledToFit()
    }
}

#Preview {
    ClickableAlbumCover(cover: Image("tpab"))
}

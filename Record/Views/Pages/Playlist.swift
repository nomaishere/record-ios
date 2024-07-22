//
//  Playlist.swift
//  Record
//
//  Created by nomamac2 on 5/26/24.
//

import SwiftUI

struct Playlist: View {
    var body: some View {
        Spacer()
            .frame(height: 24)
        DomainHeader(domainName: "PLAYLIST", handler: { NSLog("hi") }, actionButtonText: "Create")
    }
}

#Preview {
    Playlist()
}

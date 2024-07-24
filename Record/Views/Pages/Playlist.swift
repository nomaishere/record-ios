//
//  Playlist.swift
//  Record
//
//  Created by nomamac2 on 5/26/24.
//

import SwiftData
import SwiftUI

struct Playlist: View {
    @Query var tracks: [Track]
    @Query var artists: [Artist]
    var body: some View {
        Spacer()
            .frame(height: 24)
        DomainHeader(domainName: "PLAYLIST", handler: { NSLog("hi") }, actionButtonText: "Create")
        /*
         ScrollView {
             VStack {
                 ForEach(tracks) { track in
                     HStack {
                         Text(track.title)
                         Spacer()
                         Text("\(track.artists.count)")
                     }
                 }
             }
             Text("Track")
             ForEach(artists) { artist in
                 if let tracks = artist.tracks {
                     VStack {
                         ForEach(tracks) { track in
                             Text("Trackname: \(track.title)")
                         }
                     }
                 }
             }
         }*/
        Spacer()
    }
}

#Preview {
    Playlist()
}

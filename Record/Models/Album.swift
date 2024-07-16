//
//  Album.swift
//  Record
//
//  Created by nomamac2 on 5/24/24.
//

import Foundation
import SwiftData

@Model
final class Album: Identifiable {
    var id: UUID = UUID()
    var title: String
    @Relationship var artist: [Artist]
    @Relationship(inverse: \Track.album) var tracks: [Track]

    var artwork: URL

    var releaseDate: Date?
    var themeColor: String

    init(title: String, artist: [Artist], tracks: [Track], artwork: URL, releaseDate: Date, themeColor: String) {
        self.title = title
        self.artist = artist
        self.tracks = tracks
        self.artwork = artwork
        self.releaseDate = releaseDate
        self.themeColor = themeColor
    }
}

//
//  Track.swift
//  Record
//
//  Created by nomamac2 on 5/30/24.
//

import Foundation
import SwiftData

@Model
final class Track: Identifiable {
    var id: UUID = UUID()
    var title: String
    var audioLocalURL: URL

    /// length of the audio file(track). 1 = 1s
    var duration: Double

    var artwork: URL

    @Relationship var album: Album?
    @Relationship(inverse: \Artist.tracks) var artists: [Artist]
    var trackNumber: Int

    /// hex
    var themeColor: String

    init(title: String, audioLocalURL: URL, duration: Double, artwork: URL, album: Album? = nil, artists: [Artist] = [], trackNumber: Int, themeColor: String) {
        self.title = title
        self.audioLocalURL = audioLocalURL
        self.duration = duration
        self.artwork = artwork
        self.album = album
        self.artists = artists
        self.trackNumber = trackNumber
        self.themeColor = themeColor
    }
}

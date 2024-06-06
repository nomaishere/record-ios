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
    @Relationship var tracks: [Track]
    
    @Attribute(.externalStorage) var artwork: Data
    
    
    var releaseDate: Date?
    
    
    init(title: String, artist: [Artist], tracks: [Track], artwork: Data, releaseDate: Date ) {
        self.title = title
        self.artist = artist
        self.tracks = tracks
        self.artwork = artwork
        self.releaseDate = releaseDate
    }
}

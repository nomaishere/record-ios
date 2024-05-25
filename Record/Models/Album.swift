//
//  Album.swift
//  Record
//
//  Created by nomamac2 on 5/24/24.
//

import Foundation
import SwiftData

@Model
final class Album {
    var title: String
    @Relationship var artist: [Artist]
    var releaseDate: Date?
    @Attribute(.externalStorage) var coverImage: Data
    
    init(title: String, artist: [Artist], coverImage: Data ) {
        self.title = title
        self.artist = artist
        self.coverImage = coverImage
    }
}

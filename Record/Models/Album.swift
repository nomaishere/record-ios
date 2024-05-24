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
    var name: String
    @Relationship var artist: [Artist]
    var releaseDate: Date?
    
    init(name: String, artist: [Artist]) {
        self.name = name
        self.artist = artist
    }
}

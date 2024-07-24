//
//  Artist.swift
//  Record
//
//  Created by nomamac2 on 5/24/24.
//

import Foundation
import SwiftData

@Model
final class Artist: Identifiable {
    var id: UUID = UUID()
    var name: String
    var isGroup: Bool
    @Relationship var member: [Artist]?

    @Relationship var albums: [Album]?
    @Relationship var tracks: [Track]?

    init(name: String, isGroup: Bool, albums: [Album]? = nil, tracks: [Track]? = nil) {
        self.name = name
        self.isGroup = isGroup
        self.albums = albums
        self.tracks = tracks
    }
}

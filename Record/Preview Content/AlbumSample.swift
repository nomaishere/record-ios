//
//  AlbumSample.swift
//  Record
//
//  Created by nomamac2 on 5/24/24.
//

import Foundation

extension Album {
    static var sampleAlbums: [Album] {
        [
            Album(title: "Mr. Morale & the Big Steppers", artist: [Artist(name: "Kendrick Lamar", isGroup: false)], coverImage: Data()),
        ]
    }
}

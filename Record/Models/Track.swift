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
    @Attribute(.externalStorage) var audioData: Data
    
    /// length of the audio file(track). 1 = 1s
    var duration: Double
    
    var album: Album
    var artists: [Artist]
    var trackNumber: Int
    
    
    init(title: String, audioData: Data, duration: Double, album: Album, artists: [Artist], trackNumber: Int) {
        self.title = title
        self.audioData = audioData
        self.duration = duration
        self.album = album
        self.artists = artists
        self.trackNumber = trackNumber
    }
    
}

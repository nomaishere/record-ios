//
//  AlbumImportManager.swift
//  Record
//
//  Created by nomamac2 on 5/29/24.
//

import Foundation
import SwiftUI

final class ImportManager: ObservableObject {
    public enum importSteps: Codable, Hashable {
        case IMPORT
        case TRACKLIST
        case METADATA
        case CHECK
    }

    @Published var nowStep: importSteps = .IMPORT

    var selectedFilesURL: [URL] = []

    // Track Data
    @Published var tracks: [Track] = []

    // Album Metadata
    @Published var title: String = ""
    @Published var artists: [Artist] = []
    @Published var artwork: URL = .init(string: "s")!
    @Published var themeColor: String = ""

    func makeTracktempDatas() -> [TrackTempData] {
        var trackTempDatas: [TrackTempData] = []

        for (index, url) in self.selectedFilesURL.enumerated() {
            trackTempDatas.append(TrackTempData(title: url.deletingPathExtension().lastPathComponent, trackNumber: index + 1, fileURL: url, artists: []))
        }

        return trackTempDatas
    }

    func addAlbumToCollection() {
        NSLog("ImportManager: Start adding album to collection")
    }
}

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

    // FOR TEST
    @Published var nowStep: importSteps = .IMPORT

    var selectedFilesURL: [URL] = []

    func makeTracktempDatas() -> [TrackTempData] {
        var trackTempDatas: [TrackTempData] = []

        for (index, url) in self.selectedFilesURL.enumerated() {
            trackTempDatas.append(TrackTempData(title: url.lastPathComponent, trackNumber: index + 1, fileURL: url))
        }

        return trackTempDatas
    }
    
    func addAlbumToCollection() -> Void {
        print("hi")
    }
}

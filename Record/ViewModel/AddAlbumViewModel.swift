//
//  AlbumImportManager.swift
//  Record
//
//  Created by nomamac2 on 5/29/24.
//

import Foundation
import SwiftUI

struct TrackMetadata: Identifiable, Equatable, Hashable {
    let id = UUID()
    var title: String
    var trackNumber: Int
    var fileURL: URL
    var artists: [Artist]
}

final class AddAlbumViewModel: ObservableObject {
    public enum importSteps: Codable, Hashable {
        case IMPORT
        case TRACKLIST
        case METADATA
        case CHECK
    }

    @Published var nowStep: importSteps = .IMPORT
    @Published var isNextEnabled: Bool = false

    var selectedFilesURL: [URL] = []

    // Track Data
    @Published var trackMetadatas: [TrackMetadata] = []
    @Published var tracks: [Track] = []

    // Album Metadata
    @Published var title: String = ""
    @Published var artists: [Artist] = []
    @Published var artworkURL: URL = .init(string: "s")!
    @Published var themeColor: String = ""

    var coverImage: UIImage? = nil

    func makeTrackMetadataFromFiles() -> [TrackMetadata] {
        var trackTempDatas: [TrackMetadata] = []

        for (index, url) in selectedFilesURL.enumerated() {
            trackTempDatas.append(TrackMetadata(title: url.deletingPathExtension().lastPathComponent, trackNumber: index + 1, fileURL: url, artists: []))
        }

        return trackTempDatas
    }

    func movePreviousStep() {
        withAnimation {
            switch self.nowStep {
            case .IMPORT:
                break
            case .TRACKLIST:
                self.nowStep = .IMPORT
            case .METADATA:
                self.nowStep = .TRACKLIST
            case .CHECK:
                self.nowStep = .METADATA
            }
            self.isNextEnabled = true
        }
    }

    /// This method doesn't contain "complete" action that add album to collection because of swiftData
    func moveNextStep() {
        withAnimation {
            if self.isNextEnabled {
                switch self.nowStep {
                case .IMPORT:
                    self.trackMetadatas = self.makeTrackMetadataFromFiles()
                    self.nowStep = .TRACKLIST
                case .TRACKLIST:
                    self.nowStep = .METADATA
                case .METADATA:
                    self.nowStep = .CHECK
                case .CHECK:
                    break
                }
            }
        }
    }

    func addAlbumToCollection() {
        // MARK: 1) Fetch Artist Model

        // let targetArtists
    }
}

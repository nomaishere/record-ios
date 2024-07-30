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
    @Published var artwork: URL = .init(string: "s")!
    @Published var themeColor: String = ""

    var coverImage: Image? = nil

    func makeTrackMetadataFromFiles() -> [TrackMetadata] {
        var trackTempDatas: [TrackMetadata] = []

        for (index, url) in self.selectedFilesURL.enumerated() {
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
                    self.addAlbumToCollection()
                }
            }
        }
    }

    func addAlbumToCollection() {
        NSLog("ImportManager: Start adding album to collection")
    }
}

//
//  StorageManager.swift
//  Record
//
//  Created by nomamac2 on 7/18/24.
//

import Foundation

final class StorageManager {
    static let shared = StorageManager()

    private init() {}

    enum saveAudioFileError: Error {
        case notSuppportedFeature
        case encodeFailed
        case alreadyFileExisted
        case copyFailed
    }

    /// Create album directory at Document. This method must be called at Application's initialization.
    func setup() {
        // Check does albums directory exist
        NSLog("StorageManager: Start storage setup")
        if !FileManager.default.fileExists(atPath: URL.documentsDirectory.appending(component: "albums").path()) {
            NSLog("StorageManager: There was no albums directory at document, now system create that")
            do {
                try FileManager.default.createDirectory(atPath: URL.documentsDirectory.appending(component: "albums").path(), withIntermediateDirectories: false)
            } catch {
                NSLog("\(error)")
            }
        }
    }

    func createAlbumDirectory(title: String) -> URL? {
        let targetURL = URL.documentsDirectory.appending(component: "albums").appending(component: title)
        let targetURLWithoutDocument = URL(string: "albums")!.appending(component: title)

        // Create specific album directory
        if FileManager.default.fileExists(atPath: targetURL.path()) {
            return targetURLWithoutDocument
        } else {
            do {
                try FileManager.default.createDirectory(atPath: targetURL.path(), withIntermediateDirectories: false)
                return targetURLWithoutDocument
            } catch {
                NSLog("\(error)")
                return nil
            }
        }
    }

    func saveTrackAudioFileAtDocumentByOriginURL(origin: URL, title: String, album: Album?) throws -> URL {
        guard let album = album else {
            NSLog("StorageManager: Application doesn't support saving tracks that don't belong to any album. ")
            throw saveAudioFileError.notSuppportedFeature
        }

        guard let encodedAlbumTitle = album.title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            NSLog("StorageManager: Failed to encode album title")
            throw saveAudioFileError.encodeFailed
        }

        guard let encodedTrackTitle = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            NSLog("StorageManager: Failed to encode album title")
            throw saveAudioFileError.encodeFailed
        }
        let dstURLWithoutDocument = URL(string: "albums/\(encodedAlbumTitle)/\(encodedTrackTitle)")!
        let dstURL = URL.documentsDirectory.appending(path: dstURLWithoutDocument.path(percentEncoded: true))

        if FileManager.default.fileExists(atPath: dstURL.path(percentEncoded: true)) {
            throw saveAudioFileError.alreadyFileExisted
        }

        do {
            // try FileManager.default.copyItem(at: origin, to: dstURL)

            try FileManager.default.copyItem(at: origin, to: URL.documentsDirectory.appending(component: "albums/\(encodedAlbumTitle)/\(title).mp3"))

        } catch {
            NSLog("\(error)")
            throw saveAudioFileError.copyFailed
        }
        return dstURLWithoutDocument
    }
}

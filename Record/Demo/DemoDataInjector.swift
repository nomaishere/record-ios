//
//  DemoDataInjector.swift
//  Record
//
//  Created by nomamac2 on 7/1/24.
//

import Foundation
import SwiftData
import UIKit

class DemoDataInjector {
    static let sharedInstance = DemoDataInjector()

    func saveDemoAlbumImage() {
        let coverURL = URL.documentsDirectory.appending(path: "msva_cover.png")
        saveImage(UIImage(named: "msva"), at: coverURL)
    }

    func makeDemoTracksOfDemoAlbum(artist: Artist, album: Album) -> [Track] {
        let coverURL = URL(string: "msva_cover.png")!

        var tracks: [Track] = []
        let trackNames = ["Key", "Door", "Subwoofer Lullaby", "Death", "Living Mice", "Moog City", "Haggstrom", "Minecraft", "Oxygène", "Équinoxe", "Mice on Venus", "Dry Hands", "Wet Hands", "Clark", "Chris", "Thirteen", "Excuse", "Sweden", "Cat", "Dog", "Danny", "Beginning", "Droopy Likes Ricochet", "Droopy Likes Your Face"]

        for (index, trackName) in trackNames.enumerated() {
            var fileName = String(index + 1)
            if index + 1 <= 9 {
                fileName = "0" + fileName
            }
            fileName = "\(fileName) - \(trackName)"
            do {
                // let originPath = Bundle.main.path(forResource: "\(fileName)", ofType: "mp3")!
                // let originURL = URL(filePath: originPath)

                if let originURL = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
                    let savedAudioFileURL = try StorageManager.shared.saveTrackAudioFileAtDocumentByOriginURL(origin: originURL, title: trackName, album: album)
                    tracks.append(Track(title: trackName, audioLocalURL: savedAudioFileURL, duration: 30.0, artwork: coverURL, album: album, artists: [artist], trackNumber: index + 1, themeColor: "66A53D"))
                } else {
                    NSLog("System: Failed to find files at ")
                }

            } catch {
                // NSLog("System: Failed to save file ")
            }
        }

        return tracks
    }

    func saveImage(_ image: UIImage?, at url: URL) {
        if let image = image {
            if let data = image.pngData() {
                try? data.write(to: url)
            }
        } else {
            // try? FileManager.default.removeItem(at: self)
        }
    }

    func makePlayableDemoTrack() -> [Track] {
        let coverURL = URL.documentsDirectory.appending(path: "modm_cover.png")
        saveImage(UIImage(named: "modm_highres"), at: coverURL)

        var tracks: [Track] = []

        let demoArtist = Artist(name: "Khundi Panda", isGroup: false)

        let track1Path = Bundle.main.path(forResource: "01 Modm Intro.aif", ofType: nil)!
        let track1URL = URL(filePath: track1Path)
        let track1 = Track(title: "Modm Intro", audioLocalURL: track1URL, duration: 30.0, artwork: URL.documentsDirectory.appending(path: "modm_cover.png"), album: nil, artists: [demoArtist], trackNumber: 1, themeColor: "28DD9A")
        tracks.append(track1)

        let track2Path = Bundle.main.path(forResource: "02 Somozu Combat.aif", ofType: nil)!
        let track2URL = URL(filePath: track2Path)
        let track2 = Track(title: "Somozu Combat", audioLocalURL: track2URL, duration: 30.0, artwork: URL.documentsDirectory.appending(path: "modm_cover.png"), album: nil, artists: [demoArtist], trackNumber: 2, themeColor: "28DD9A")
        tracks.append(track2)

        let track3Path = Bundle.main.path(forResource: "03 Main Pool (Featuring Gray).aif", ofType: nil)!
        let track3URL = URL(filePath: track3Path)
        let track3 = Track(title: "Main Pool", audioLocalURL: track3URL, duration: 30.0, artwork: URL.documentsDirectory.appending(path: "modm_cover.png"), album: nil, artists: [demoArtist], trackNumber: 3, themeColor: "28DD9A")
        tracks.append(track3)

        return tracks
    }
}

//
//  DemoDataInjector.swift
//  Record
//
//  Created by nomamac2 on 7/1/24.
//

import Foundation
import UIKit

class DemoDataInjector {
    static let sharedInstance = DemoDataInjector()

    func storeDemoAlbumAtDocument() {
        let coverURL = URL.documentsDirectory.appending(path: "modm_cover.png")
        saveImage(UIImage(named: "modm_highres"), at: coverURL)
    }

    func saveImage(_ image: UIImage?, at url: URL) {
        if let image = image {
            if let data = image.pngData() {
                try? data.write(to: url)
                NSLog("Store Image!")
            }
        } else {
            // try? FileManager.default.removeItem(at: self)
        }
    }

    func makePlayableDemoTrack() -> [Track] {
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

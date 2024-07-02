//
//  DemoDataInjector.swift
//  Record
//
//  Created by nomamac2 on 7/1/24.
//

import Foundation
import UIKit

class DemoDataInjector {
    func storeDemoAlbumAtDocument() {
        let coverURL = URL.documentsDirectory.appending(path: "modm_cover.png")
        saveImage(UIImage(named: "modm_highres"), at: coverURL)

        let track1Path = Bundle.main.path(forResource: "01 Modm Intro.aif", ofType: nil)!
        //let track2Path = Bundle.main.path(f)
        let url = URL(filePath: path)
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
}

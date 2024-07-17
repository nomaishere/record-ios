//
//  More.swift
//  Record
//
//  Created by nomamac2 on 5/26/24.
//

import SwiftData
import SwiftUI

struct More: View {
    @EnvironmentObject var audioManager: AudioManager
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Spacer()
            .frame(height: 24)
        HStack(alignment: .center) {
            Text("MORE")
                .font(Font.custom("ProFont For Powerline", size: 32))
                .foregroundStyle(Color("DefaultBlack"))
            Spacer()
            Button("Setting", action: { print("create") })
                .padding(.vertical, 4.0)
                .padding(.horizontal, 24)
                .background(Color("DefaultBlack"))
                .font(Font.custom("Poppins-Medium", size: 20)).foregroundStyle(.white)
                .clipShape(Capsule())
        }
        .padding(.horizontal, 24.0)
        Button(action: {
            audioManager.playTracksAfterCleanQueue(tracks: DemoDataInjector.sharedInstance.makePlayableDemoTrack())

        }, label: {
            Text("Play MODM")
                .padding(.vertical, 8)
        })
        Button(action: {
            if let originURL = Bundle.main.url(forResource: "01 - Key", withExtension: "mp3") {
                do {
                    try FileManager.default.copyItem(at: originURL, to: URL.documentsDirectory.appending(component: "test.mp3"))
                } catch {}
            }

        }, label: {
            Text("Test Bundle")
                .padding(.vertical, 8)

        })
        Button(action: {
            do {
                let existingAlbums = try modelContext.fetchCount(FetchDescriptor<Album>())
                if existingAlbums == 0 {
                    let demoArtist = Artist(name: "C418", isGroup: false)

                    // Default Strategy: Making Model -> Saving Files -> Updating Model's Data
                    let demoAlbum = Album(title: "Minecraft - Volume Alpha", artist: [demoArtist], tracks: [], artwork: URL(string: "msva_cover.png")!, releaseDate: Date(), themeColor: "66A53D")
                    StorageManager.shared.createAlbumDirectory(title: "Minecraft - Volume Alpha")
                    let demoTrack = DemoDataInjector.sharedInstance.makeDemoTracksOfDemoAlbum(artist: demoArtist, album: demoAlbum)
                    modelContext.insert(demoAlbum)

                    demoAlbum.tracks = demoTrack
                }
            } catch {}

        }, label: {
            Text("Add Demo Album")
                .padding(.vertical, 8)

        })
    }
}

#Preview {
    More()
}

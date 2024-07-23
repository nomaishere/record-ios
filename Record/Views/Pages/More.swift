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
    @Query var artists: [Artist]

    var body: some View {
        Spacer()
            .frame(height: 24)
        DomainHeader(domainName: "MORE", handler: { NSLog("hi") }, actionButtonText: "Setting")
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
        MoreFeatureGroup(sectionName: "Artist") {
            MoreFeatureItem(icon: Image("plus"), text: "View Artists", onTabAction: {})
        }
        VStack {
            if artists.isEmpty {
                Text("No Artist")
            } else {
                ForEach(artists) { artist in
                    Text(artist.name)
                }
            }
        }
        Spacer()
    }
}

struct MoreFeatureGroup<Content: View>: View {
    let sectionName: String

    @ViewBuilder var content: () -> Content
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(sectionName)
                    .font(Font.custom("Poppins-SemiBold", size: 20))
                    .foregroundStyle(Color("DefaultBlack"))
                Spacer()
            }
            VStack(spacing: 4) {
                content()
            }
        }
        .padding(.horizontal, 20)
    }
}

struct MoreFeatureItem: View {
    let icon: Image
    let text: String
    let onTabAction: () -> Void

    var body: some View {
        Button(action: { onTabAction() }, label: {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color("G1"))
                    RectIconWrapper(icon: icon, color: Color("G6"), iconWidth: 20, wrapperWidth: 40, wrapperHeight: 40)
                }
                .frame(width: 40, height: 40)
                Text(text)
                    .font(Font.custom("Pretendard-Medium", size: 20))
                    .foregroundStyle(Color("G7"))
            }
            .padding(.vertical, 4)
        })
    }
}

#Preview {
    More()
}

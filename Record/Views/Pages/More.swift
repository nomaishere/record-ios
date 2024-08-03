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
        VStack(spacing: 0) {
            Spacer.vertical(24)
            DomainHeader(domainName: "MORE", handler: { NSLog("hi") }, actionButtonText: "Setting")
            /*
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
             */
            Spacer.vertical(24)
            SimpleDashboard()
            Spacer.vertical(24)
            ScrollView {
                MoreFeatureGroup(sectionName: "Tracks") {
                    MoreFeatureItem(icon: Image("music-solid"), text: "View All Tracks", onTabAction: {})
                }
                MoreFeatureGroup(sectionName: "Artists") {
                    MoreFeatureItem(icon: Image("plus"), text: "Manage Artists", onTabAction: {})
                    MoreFeatureItem(icon: Image("plus"), text: "Add Artist", onTabAction: {})
                }
                Spacer.vertical(24)
                MoreFeatureGroup(sectionName: "Developer Only") {
                    MoreFeatureItem(icon: Image("plus"), text: "Add Demo Album(v1)", onTabAction: {
                        do {
                            let existingAlbums = try modelContext.fetchCount(FetchDescriptor<Album>())
                            if existingAlbums == 0 {
                                let demoArtist = Artist(name: "C418", isGroup: false)
                                
                                let demoAlbum = Album(title: "Minecraft - Volume Alpha", artist: [demoArtist], tracks: [], artwork: URL(string: "msva_cover.png")!, releaseDate: Date(), themeColor: "66A53D")
                                _ = StorageManager.shared.createAlbumDirectory(title: "Minecraft - Volume Alpha")
                                let demoTrack = DemoDataInjector.sharedInstance.makeDemoTracksOfDemoAlbum(artist: demoArtist, album: demoAlbum)
                                
                                modelContext.insert(demoAlbum)
                                
                                demoAlbum.tracks = demoTrack
                            }
                        } catch {}
                        
                    })
                    MoreFeatureItem(icon: Image("plus"), text: "Add Demo Album(v2)", onTabAction: {
                        do {
                            let existingAlbums = try modelContext.fetchCount(FetchDescriptor<Album>())
                            if existingAlbums == 0 {
                                // MARK: 1) Create Artist Model
                                
                                let demoArtist = Artist(name: "C418", isGroup: false)
                                
                                // MARK: 2) Add Albums without Tracks At ModelContainer
                                
                                let demoAlbum = Album(title: "Minecraft - Volume Alpha", artist: [], tracks: [], artwork: URL(string: "msva_cover.png")!, releaseDate: Date(), themeColor: "66A53D")
                                _ = StorageManager.shared.createAlbumDirectory(title: "Minecraft - Volume Alpha")
                                
                                // MARK: 3) Add Tracks
                                
                                var demoTracks: [Track] = []
                                let trackNames = ["Key", "Door", "Subwoofer Lullaby", "Death", "Living Mice", "Moog City", "Haggstrom", "Minecraft", "Oxygène", "Équinoxe", "Mice on Venus", "Dry Hands", "Wet Hands", "Clark", "Chris", "Thirteen", "Excuse", "Sweden", "Cat", "Dog", "Danny", "Beginning", "Droopy Likes Ricochet", "Droopy Likes Your Face"]
                                
                                for (index, trackName) in trackNames.enumerated() {
                                    var fileName = String(index + 1)
                                    if index + 1 <= 9 {
                                        fileName = "0" + fileName
                                    }
                                    fileName = "\(fileName) - \(trackName)"
                                    do {
                                        if let originURL = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
                                            let savedAudioFileURL = try StorageManager.shared.saveTrackAudioFileAtDocumentByOriginURL(origin: originURL, title: trackName, album: demoAlbum)
                                            demoTracks.append(Track(title: trackName, audioLocalURL: savedAudioFileURL, duration: 30.0, artwork: URL(string: "msva_cover.png")!, album: nil, artists: [], trackNumber: index + 1, themeColor: "66A53D"))
                                        } else {
                                            NSLog("System: Failed to find files at ")
                                        }
                                        
                                    } catch {}
                                }
                                
                                // MARK: 4) Insert Model First
                                
                                modelContext.insert(demoAlbum)
                                
                                // MARK: 5) Link Relationship Between Models
                                
                                demoArtist.albums = [demoAlbum]
                                demoArtist.tracks = demoTracks
                                
                                demoAlbum.artist = [demoArtist]
                                demoAlbum.tracks = demoTracks
                                
                                for demoTrack in demoTracks {
                                    demoTrack.artists = [demoArtist]
                                    demoTrack.album = demoAlbum
                                }
                                
                                // MARK: 6) Save ModelContext Changes Manually

                                if modelContext.hasChanges {
                                    NSLog("Save Album")
                                    do {
                                        try modelContext.save()
                                    } catch {
                                        NSLog("Failed to save")
                                    }
                                }
                            }
                        } catch {}
                    })
                    MoreFeatureItem(icon: Image("plus"), text: "Add Artist", onTabAction: {
                        let demoArtist = Artist(name: "C418", isGroup: false)
                        modelContext.insert(demoArtist)
                        
                        if modelContext.hasChanges {
                            NSLog("Save Artist")
                            do {
                                try modelContext.save()
                            } catch {
                                NSLog("Failed to save")
                            }
                        }
                    })
                    MoreFeatureItem(icon: Image("plus"), text: "Add Demo Album(v3)", onTabAction: {
                        do {
                            let existingAlbums = try modelContext.fetchCount(FetchDescriptor<Album>())
                            if existingAlbums == 0 {
                                // MARK: 1) Fetch Artist Model
                                
                                guard let demoArtist = try modelContext.fetch(FetchDescriptor<Artist>(predicate: #Predicate { $0.name == "C418" })).first else {
                                    NSLog("No C418")
                                    return
                                }
                                
                                // MARK: 2) Add Albums without Tracks At ModelContainer
                                
                                let demoAlbum = Album(title: "Minecraft - Volume Alpha", artist: [], tracks: [], artwork: URL(string: "msva_cover.png")!, releaseDate: Date(), themeColor: "66A53D")
                                _ = StorageManager.shared.createAlbumDirectory(title: "Minecraft - Volume Alpha")
                                
                                // MARK: 3) Add Tracks
                                
                                var demoTracks: [Track] = []
                                let trackNames = ["Key", "Door", "Subwoofer Lullaby", "Death", "Living Mice", "Moog City", "Haggstrom", "Minecraft", "Oxygène", "Équinoxe", "Mice on Venus", "Dry Hands", "Wet Hands", "Clark", "Chris", "Thirteen", "Excuse", "Sweden", "Cat", "Dog", "Danny", "Beginning", "Droopy Likes Ricochet", "Droopy Likes Your Face"]
                                
                                for (index, trackName) in trackNames.enumerated() {
                                    var fileName = String(index + 1)
                                    if index + 1 <= 9 {
                                        fileName = "0" + fileName
                                    }
                                    fileName = "\(fileName) - \(trackName)"
                                    do {
                                        if let originURL = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
                                            let savedAudioFileURL = try StorageManager.shared.saveTrackAudioFileAtDocumentByOriginURL(origin: originURL, title: trackName, album: demoAlbum)
                                            demoTracks.append(Track(title: trackName, audioLocalURL: savedAudioFileURL, duration: 30.0, artwork: URL(string: "msva_cover.png")!, album: nil, artists: [], trackNumber: index + 1, themeColor: "66A53D"))
                                        } else {
                                            NSLog("System: Failed to find files at ")
                                        }
                                        
                                    } catch {}
                                }
                                
                                // MARK: 4) Insert Model First
                                
                                modelContext.insert(demoAlbum)
                                
                                // MARK: 5) Link Relationship Between Models
                                
                                demoArtist.albums = [demoAlbum]
                                demoArtist.tracks = demoTracks
                                
                                demoAlbum.artist = [demoArtist]
                                demoAlbum.tracks = demoTracks
                                
                                for demoTrack in demoTracks {
                                    demoTrack.artists = [demoArtist]
                                    demoTrack.album = demoAlbum
                                }
                                
                                // MARK: 6) Save ModelContext Changes Manually

                                if modelContext.hasChanges {
                                    NSLog("Save Album")
                                    do {
                                        try modelContext.save()
                                    } catch {
                                        NSLog("Failed to save")
                                    }
                                }
                            }
                        } catch {}
                    })
                }
            }
        }
    }
}

struct SimpleDashboard: View {
    @Query var albums: [Album]
    @Query var tracks: [Track]
    @Query var artists: [Artist]

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .foregroundStyle(Color("G1"))
                .frame(height: 120)
            HStack {
                Spacer()
                VStack(spacing: 0) {
                    Text("\(albums.count)")
                        .font(Font.custom("Poppins-SemiBold", size: 24))
                        .foregroundStyle(Color("DefaultBlack"))
                    Text("albums")
                        .font(Font.custom("Pretendard-SemiBold", size: 16))
                        .foregroundStyle(Color("G5"))
                }
                Spacer()
                VStack(spacing: 0) {
                    Text("\(tracks.count)")
                        .font(Font.custom("Poppins-SemiBold", size: 24))
                        .foregroundStyle(Color("DefaultBlack"))
                    Text("tracks")
                        .font(Font.custom("Pretendard-SemiBold", size: 16))
                        .foregroundStyle(Color("G5"))
                }
                Spacer()
                VStack(spacing: 0) {
                    Text("\(artists.count)")
                        .font(Font.custom("Poppins-SemiBold", size: 24))
                        .foregroundStyle(Color("DefaultBlack"))
                    Text("artists")
                        .font(Font.custom("Pretendard-SemiBold", size: 16))
                        .foregroundStyle(Color("G5"))
                }
                Spacer()
            }
        }
        .padding(.horizontal, 16)
    }
}

struct MoreFeatureGroup<Content: View>: View {
    let sectionName: String

    @ViewBuilder var content: () -> Content
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(sectionName)
                    .font(Font.custom("Poppins-SemiBold", size: 18))
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
                    RectIconWrapper(icon: icon, color: Color("G6"), iconWidth: 16, wrapperWidth: 40, wrapperHeight: 40)
                }
                .frame(width: 40, height: 40)
                Text(text)
                    .font(Font.custom("Pretendard-Medium", size: 18))
                    .foregroundStyle(Color("G7"))
                Spacer()
            }
            .padding(.vertical, 4)
        })
    }
}

#Preview {
    More()
}

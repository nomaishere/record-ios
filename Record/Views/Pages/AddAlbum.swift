//
//  AddAlbum.swift
//  Record
//
//  Created by nomamac2 on 5/26/24.
//

import SwiftData
import SwiftUI

struct AddAlbum: View {
    @EnvironmentObject var router: Router
    @Environment(\.modelContext) private var modelContext

    @ObservedObject var viewModel = AddAlbumViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Color.clear
                        .frame(height: 0)
                        .background(Color("G1").ignoresSafeArea())
                    UnevenRoundedRectangle(cornerRadii: .init(
                        topLeading: 0,
                        bottomLeading: 40, bottomTrailing: 40, topTrailing: 0
                    ), style: .continuous)
                        .fill(Color("G1"))
                        .strokeBorder(Color("G2"), lineWidth: 2, antialiased: true)
                        .border(width: 2, edges: [.top], color: Color("G1"))
                        .frame(height: 128, alignment: .top)
                        .overlay(
                            VStack(spacing: 0) {
                                ZStack {
                                    HStack {
                                        Button {
                                            router.navigateBack()
                                        } label: {
                                            Image("LeftChevron")
                                                .frame(width: 48, height: 48)
                                                .foregroundColor(Color("G6"))
                                                .background(.white)
                                                .clipShape(Circle())
                                                .shadow(color: Color("G2"), radius: 8, y: 2)
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                    Text("Add Album")
                                        .font(Font.custom("Poppins-Medium", size: 20))
                                        .foregroundStyle(Color("G7"))
                                }
                                .padding(.bottom, 24)
                                ProgressWithText(steps: [Step(id: 1, name: "Import"), Step(id: 2, name: "Tracklist"), Step(id: 3, name: "Metadata"), Step(id: 4, name: "Check")])
                                    .padding(.bottom, 24)
                                    .environmentObject(viewModel)

                            },
                            alignment: .top
                        )
                        .navigationBarBackButtonHidden()
                }
                Group {
                    switch viewModel.nowStep {
                    case .IMPORT:
                        AddAlbum_Import()
                    case .TRACKLIST:
                        AddAlbum_Tracklist()
                    case .METADATA:
                        AddAlbum_Metadata()
                    case .CHECK:
                        AddAlbum_Check()
                    }
                }
                .environmentObject(viewModel)
            }
            // Wrap VStack to apply ignoreSafeArea(.keyboard)

            // Bottom Navigation Bar
            VStack {
                Spacer()
                VStack(spacing: 0) {
                    Color("G2")
                        .frame(height: 2)
                        .padding(.all, 0)
                    HStack(spacing: 15.5) {
                        if viewModel.nowStep != .IMPORT {
                            Button(action: { viewModel.movePreviousStep() }, label: {
                                HStack {
                                    Image("LeftChevron")
                                        .renderingMode(.template)
                                        .frame(height: 16)
                                    Spacer()
                                        .frame(width: 6)
                                    Text("Before")
                                        .font(Font.custom("Poppins-Medium", size: 20))
                                }
                                .foregroundStyle(Color("G5"))
                            })
                            .padding(.leading, 8)
                        }
                        Spacer()
                        Button(viewModel.nowStep == .CHECK ? "Complete" : "Next Step", action: {
                            if viewModel.nowStep == .CHECK {
                                // MARK: 1) Fetch Artist Model

                                var targetArtists: [Artist] = []
                                for artist in viewModel.artists {
                                    do {
                                        // TODO: This line doesn't support for multiple artists that has same name.
                                        let artistID = artist.id
                                        guard let fetchedArtist = try modelContext.fetch(FetchDescriptor<Artist>(predicate: #Predicate { $0.id == artistID })).first else {
                                            NSLog("AddAlbum: Can't find artist at system")
                                            return
                                        }
                                        targetArtists.append(fetchedArtist)
                                    } catch {
                                        NSLog("AddAlbum: Failed to find artist")
                                    }
                                }

                                // MARK: 2) All Albums without Tracks at ModelContainer & Create Album Directory

                                guard let albumDirectory = StorageManager.shared.createAlbumDirectory(title: viewModel.title) else {
                                    NSLog("AddAlbum: Failed to create album directory")
                                    return
                                }
                                guard let artwork = viewModel.coverImage else { return }
                                guard let targetArtworkURL = StorageManager.shared.updateAlbumArtworkByAlbumDirectory(albumDirectory: albumDirectory, artwork: artwork) else { return }
                                let targetAlbum = Album(title: viewModel.title, artist: [], tracks: [], artwork: targetArtworkURL, releaseDate: Date(), themeColor: viewModel.themeColor)

                                // MARK: 3) Add Tracks

                                var targetTracks: [Track] = []
                                NSLog("AddAlbum: Start saving \(viewModel.trackMetadatas.count) tracks")
                                for trackMetadata in viewModel.trackMetadatas {
                                    do {
                                        let savedAudioFileURL = try StorageManager.shared.saveTrackAudioFileAtDocumentByOriginURL(origin: trackMetadata.fileURL, isSecurityScopedURL: true, title: trackMetadata.title, album: targetAlbum)
                                        targetTracks.append(Track(title: trackMetadata.title, audioLocalURL: savedAudioFileURL, duration: 0.0, artwork: viewModel.artworkURL, album: targetAlbum, artists: [], trackNumber: trackMetadata.trackNumber, themeColor: viewModel.themeColor))
                                    } catch {
                                        NSLog("AddAlbum: Failed to save track '\(trackMetadata.title)'.")
                                        return
                                    }
                                }

                                // MARK: 4) Insert Model First

                                modelContext.insert(targetAlbum)

                                // MARK: 5) Link Relationship Between Models

                                for targetArtist in targetArtists {
                                    targetArtist.albums?.append(targetAlbum)
                                    targetArtist.tracks?.append(contentsOf: targetTracks)
                                }

                                targetAlbum.artist = targetArtists
                                targetAlbum.tracks = targetTracks

                                for targetTrack in targetTracks {
                                    targetTrack.artists = targetArtists
                                    targetTrack.album = targetAlbum
                                }

                                // MARK: 6) Save ModelContext Changes Manually

                                if modelContext.hasChanges {
                                    NSLog("Success to add album. ")
                                    do {
                                        try modelContext.save()
                                    } catch {
                                        NSLog("Failed to save")
                                    }
                                }

                            } else {
                                viewModel.moveNextStep()
                            }
                        })
                        .padding(.vertical, 8.0)
                        .padding(.horizontal, 32.0)
                        .background(viewModel.isNextEnabled ? Color("DefaultBlack") : Color("G3"))
                        .font(Font.custom("Poppins-Medium", size: 20))
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                    }
                    .padding(.top, 14)
                    .padding(.horizontal, 16)
                }
                .frame(maxWidth: .infinity, minHeight: 59, maxHeight: 59, alignment: .top)
                .background(Color("G1"))
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}

#Preview {
    AddAlbum()
}

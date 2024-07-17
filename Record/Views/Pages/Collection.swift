//
//  Collection.swift
//  Record
//
//  Created by nomamac2 on 5/24/24.
//

import SwiftData
import SwiftUI

struct Collection: View {
    @Query var albums: [Album]
    @EnvironmentObject var router: Router
    @EnvironmentObject var audioManager: AudioManager

    @State var isAlbumViewPopup: Bool = false
    @State var selectedAlbum: Album? = nil

    func handleAlbumOnTabGesture(album: Album) {
        guard isAlbumViewPopup == false else { return }

        isAlbumViewPopup = true
        selectedAlbum = album
    }

    var body: some View {
        if isAlbumViewPopup {
            if let album = selectedAlbum {
                ScrollView {
                    VStack(spacing: 0) {
                        HStack {
                            Button(action: {
                                isAlbumViewPopup = false
                                selectedAlbum = nil
                            }, label: {
                                HStack(spacing: 10) {
                                    RectIconWrapper(icon: Image("LeftChevron"), color: Color("G5"), iconWidth: 8, wrapperWidth: 8, wrapperHeight: 14)
                                    Text("Collection")
                                        .font(Font.custom("Pretendard-Medium", size: 18))
                                        .foregroundStyle(Color("G5"))
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 36)
                                .background(RoundedRectangle(cornerRadius: 100)
                                    .fill(Color("G1")))
                            })
                            Spacer()
                            Button(action: {
                                audioManager.playTracksAfterCleanQueue(tracks: album.tracks.sorted(by: { $0.trackNumber < $1.trackNumber }))
                            }, label: {
                                HStack(spacing: 10) {
                                    RectIconWrapper(icon: Image("Play"), color: Color(.white), iconWidth: 12, wrapperWidth: 12, wrapperHeight: 14.18)
                                    Text("Play")
                                        .font(Font.custom("Pretendard-Medium", size: 18))
                                        .foregroundStyle(Color(.white))
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 36)
                                .background(RoundedRectangle(cornerRadius: 100)
                                    .fill(Color(hexString: album.themeColor)))
                            })
                        }
                        .padding(.horizontal, 16)
                    }
                    Spacer()
                        .frame(height: 24)
                    AsyncImage(url: URL.documentsDirectory.appending(path: album.artwork.absoluteString)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .scaledToFit()
                        } else if phase.error != nil {
                            Color.red
                        } else {}
                    }
                    .frame(width: 249, height: 249)
                    Spacer()
                        .frame(height: 12)
                    Text("\(album.title)")
                        .font(Font.custom("Pretendard-SemiBold", size: 20))
                        .foregroundStyle(Color(hexString: album.themeColor))
                    Spacer()
                        .frame(height: 4)
                    Text("\(album.artist.first!.name)")
                        .font(Font.custom("Pretendard-Medium", size: 18))
                        .foregroundStyle(Color("G5"))
                    Spacer()
                        .frame(height: 24)
                    VStack(spacing: 18) {
                        ForEach(album.tracks.sorted(by: { $0.trackNumber < $1.trackNumber }), id: \.self) { track in
                            HStack(spacing: 0) {
                                Text("\(track.trackNumber)")
                                    .font(Font.custom("Pretendard-Medium", size: 18))
                                    .foregroundStyle(Color("G3"))
                                    .frame(width: 24)
                                Spacer()
                                    .frame(width: 12)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(track.title)")
                                        .font(Font.custom("Pretendard-Medium", size: 18))
                                        .foregroundStyle(Color("DefaultBlack"))
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                }
            }
        } else {
            VStack(alignment: .center) {
                Spacer()
                    .frame(height: 24)
                HStack(alignment: .center) {
                    Text("COLLECTION")
                        .font(Font.custom("ProFont For Powerline", size: 32))
                        .foregroundStyle(Color("DefaultBlack"))
                    Spacer()
                    Button("Add", action: { router.navigate(to: .addalbum) })
                        .padding(.vertical, 4.0)
                        .padding(.horizontal, 24)
                        .background(Color("DefaultBlack"))
                        .font(Font.custom("Poppins-Medium", size: 20)).foregroundStyle(.white)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 24.0)
                Spacer()
                    .frame(height: 24)
                HStack {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color("G1"))
                            .frame(height: 48)

                        Text("Search")
                            .font(Font.custom("Poppins-Medium", size: 18))
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(Color("G3"))
                            .padding(.leading, 16.0)
                    }
                    Spacer()
                        .frame(width: 18)
                    Button {
                        print("order")
                    } label: {
                        Image("Order")
                            .frame(width: 48, height: 48)
                            .foregroundColor(Color("G3"))
                            .background(Color("G1"))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
                .padding(.horizontal, 16.0)
                Spacer()
                    .frame(height: 16)

                Button(action: {
                    audioManager.playTracksAfterCleanQueue(tracks: DemoDataInjector.sharedInstance.makePlayableDemoTrack())

                }, label: {
                    Text("Play MODM")
                })
                Button(action: {
                    if let originURL = Bundle.main.url(forResource: "01 - Key", withExtension: "mp3") {
                        do {
                            try FileManager.default.copyItem(at: originURL, to: URL.documentsDirectory.appending(component: "test"))
                        } catch {}
                    }

                }, label: {
                    Text("Text Bundle")
                })
                AlbumGridList(albums: albums, onTabGestureHander: handleAlbumOnTabGesture)
            }
        }
    }
}

#Preview {
    Collection()
}

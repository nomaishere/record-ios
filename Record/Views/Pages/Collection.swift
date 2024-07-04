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

    var body: some View {
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
                /*
                 AsyncImage(url: URL.documentsDirectory.appending(path: "modm_cover.png"))
                     .scaledToFit()
                     .frame(width: 200, height: 200)
                     .clipped()
                  */

                Text("Play MODM")
            })
            AlbumGridList(albums: [])
        }
    }
}

#Preview {
    Collection()
}

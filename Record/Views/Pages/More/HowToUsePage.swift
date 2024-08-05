//
//  HowToUsePage.swift
//  Record
//
//  Created by nomamac2 on 8/5/24.
//

import SwiftUI

extension Text {
    func bodyStyle() -> some View {
        self.font(Font.custom("Pretendard-Medium", size: 16))
            .foregroundStyle(Color("DefaultBlack"))
            .multilineTextAlignment(.leading)
    }

    func headerStyle() -> some View {
        self.font(Font.custom("Pretendard-Semibold", size: 18))
            .foregroundStyle(Color("DefaultBlack"))
            .multilineTextAlignment(.leading)
    }
}

struct HowToUsePage: View {
    var body: some View {
        Spacer.vertical(24)
        PageHeader(pageName: "How to use")
        Spacer.vertical(24)

        VStack(alignment: .leading, spacing: 4) {
            Text("About Application")
                .headerStyle()
            Text("RECORD is music player for playing audio files, especially made for cd & vinyl lovers. This app is not a streaming app like Apple Music or Spotify, so you need an audio files that ripped from CD, downloaded on online store, etc. ")
                .bodyStyle()

            Spacer.vertical(16)

            Text("How to add albums")
                .headerStyle()
            Text("1. Download audio files on your phone.")
                .bodyStyle()
            Text("2. Click \"NEW\" button at Collection tab.")
                .bodyStyle()
            Text("3. Select files, edit track title & order.")
                .bodyStyle()
            Text("4. Edit album's metadata(title, artist, cover, etc)")
                .bodyStyle()
            Text("5. Check everything fine.")
                .bodyStyle()
        }
        .padding(.horizontal, 16)
        Spacer()
    }
}

#Preview {
    HowToUsePage()
}

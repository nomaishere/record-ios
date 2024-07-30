//
//  AddAlbum_Check.swift
//  Record
//
//  Created by nomamac2 on 6/1/24.
//

import SwiftUI

struct AddAlbum_Check: View {
    @EnvironmentObject var viewModel: AddAlbumViewModel

    var numberFormatter = NumberFormatter()

    init() {
        numberFormatter.minimumIntegerDigits = 2
    }

    var body: some View {
        ScrollView {
            Spacer.vertical(32)
            if let image = viewModel.coverImage {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 249, height: 249)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            Spacer.vertical(12)
            Text("\(viewModel.title)")
                .font(Font.custom("Poppins-SemiBold", size: 20))
                .foregroundStyle(Color(hexString: "000000")) // TODO: Album Theme Color
            Spacer.vertical(4)
            Text("\(Artist.makeArtistAsString(viewModel.artists))")
                .font(Font.custom("Pretendard-Medium", size: 18))
                .foregroundStyle(Color("G5"))
            Spacer.vertical(24)

            ForEach(viewModel.tracks.sorted(by: { $0.trackNumber < $1.trackNumber }), id: \.self) { track in
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundStyle(Color(hex: 0xF8F8F8, opacity: 0.6))
                    HStack {
                        Text(numberFormatter.string(from: track.trackNumber as NSNumber)!)
                            .font(Font.custom("Pretendard-SemiBold", size: 18))
                            .foregroundStyle(Color("G3"))
                            .monospacedDigit()
                            .padding(.trailing, 8)

                        Text("\(track.title)")
                            .font(Font.custom("Pretendard-SemiBold", size: 18))
                            .foregroundStyle(Color("DefaultBlack"))
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .padding(.leading, 18)
                    .padding(.trailing, 12)
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

#Preview {
    AddAlbum_Check()
}

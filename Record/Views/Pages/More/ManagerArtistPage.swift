//
//  ManagerArtistPage.swift
//  Record
//
//  Created by nomamac2 on 8/5/24.
//

import SwiftData
import SwiftUI

struct DeleteArtistPage: View {
    @Environment(\.modelContext) var modelContext
    @Query var artists: [Artist]
    @State var isDeleteAlertPresented: Bool = false

    var body: some View {
        Spacer.vertical(24)
        PageHeader(pageName: "Delete artist")
        Spacer.vertical(24)
        VStack(spacing: 12) {
            ForEach(artists) { artist in
                HStack {
                    Text("\(artist.name)")
                        .font(Font.custom("Pretendard-SemiBold", size: 18))
                        .foregroundStyle(Color("DefaultBlack"))
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer()
                    Button(action: {
                        if let artistAlbum = artist.albums {
                            if artistAlbum.isEmpty {
                                isDeleteAlertPresented = true
                            }
                        } else {}
                    }, label: {
                        if let artistAlbum = artist.albums {
                            if artistAlbum.isEmpty {
                                RectIconWrapper(icon: Image("xmark"), color: Color(hex: 0xFF5353), iconWidth: 12, wrapperWidth: 24, wrapperHeight: 24)
                            } else {
                                RectIconWrapper(icon: Image("xmark"), color: Color("G3"), iconWidth: 12, wrapperWidth: 24, wrapperHeight: 24)
                            }
                        } else {
                            RectIconWrapper(icon: Image("xmark"), color: Color("G3"), iconWidth: 12, wrapperWidth: 24, wrapperHeight: 24)
                        }
                    })
                    .alert(
                        Text("Warning"), isPresented: $isDeleteAlertPresented
                    ) {
                        Button("Delete", role: .destructive) {
                            modelContext.delete(artist)
                        }
                    } message: {
                        Text("This operation cannot be reversed. Do you really want to delete this artist?")
                    }
                }
                .padding(.vertical, 12)
                .padding(.leading, 18)
                .padding(.trailing, 12)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundStyle(Color(hex: 0xF8F8F8, opacity: 0.6))
                )
            }
        }
        .padding(.horizontal, 16)
        Spacer()
    }
}

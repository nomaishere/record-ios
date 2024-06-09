//
//  AddAlbum_Metadata.swift
//  Record
//
//  Created by nomamac2 on 6/1/24.
//

import SwiftUI

struct AddAlbum_Metadata: View {
    @EnvironmentObject var importManager: ImportManager

    @Binding var isNextEnabled: Bool

    @State var title: String = ""
    @State var artistName: String = ""

    @State var artists: [Artist] = []

    var body: some View {
        ScrollView {
            Spacer()
                .frame(height: 32)
            VStack(spacing: 12) {
                HStack {
                    Text("Title")
                        .font(Font.custom("Poppins-SemiBold", size: 20))
                        .foregroundStyle(Color("DefaultBlack"))
                        .padding(.leading, 24)
                    Spacer()
                }
                TextField("Enter name of album", text: $title)
                    .autocorrectionDisabled()
                    .submitLabel(.done)
                    .font(Font.custom("Pretendard-SemiBold", size: 18))
                    .foregroundStyle(Color("DefaultBlack"))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 13.5)
                    .background(Color("G1"))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .padding(.horizontal, 16)
                    .onAppear {
                        UITextField.appearance().clearButtonMode = .whileEditing
                    }
            }
            Spacer()
                .frame(height: 40)
            VStack(spacing: 12) {
                HStack {
                    Text("Artist")
                        .font(Font.custom("Poppins-SemiBold", size: 20))
                        .foregroundStyle(Color("DefaultBlack"))
                        .padding(.leading, 24)
                    Spacer()
                }
                ForEach(Array($artists.enumerated()), id: \.offset) { index, artist in
                    HStack {
                        Circle()
                            .fill(Color(hex: 0xF2F2F2))
                            .frame(width: 48, height: 48)
                            .overlay {
                                Text("?")
                                    .font(Font.custom("Pretendard-SemiBold", size: 20))
                                    .foregroundStyle(Color(hex: 0xD7D7D7))
                            }
                            .padding(.all, 6)
                        TextField("name", text: artist.name)
                            .submitLabel(.done)
                            .font(Font.custom("Pretendard-SemiBold", size: 18))
                            .foregroundStyle(Color("DefaultBlack"))
                        Button(action: {
                            artists.remove(at: index)
                        }, label: {
                            RectIconWrapper(icon: Image("xmark"), color: Color(hex: 0xD5D5D5), iconWidth: 12, wrapperWidth: 32, wrapperHeight: 32)
                                .padding(.trailing, 14)
                        })
                    }
                    .background(Color("G1"))
                    .clipShape(RoundedRectangle(cornerRadius: 100.0))
                    .padding(.horizontal, 16)
                }
                Button(action: {
                    artists.append(Artist(name: "", isGroup: false))
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 100.0, style: .circular)
                            .inset(by: 1)
                            .stroke(Color("G2"), lineWidth: 2)
                            .fill(.clear)
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .padding(.all, 0)

                        Image("plus")
                            .foregroundStyle(Color("G3"))
                    }
                    .padding(.horizontal, 16)
                })
            }
            Spacer()
                .frame(height: 40)
            VStack(spacing: 12) {
                HStack {
                    Text("Cover")
                        .font(Font.custom("Poppins-SemiBold", size: 20))
                        .foregroundStyle(Color("DefaultBlack"))
                        .padding(.leading, 24)
                    Spacer()
                }
                HStack {
                    SqaureBoxButton(text: "Photos", textColor: Color("G6"), icon: Image("PhotosIcon"), action: { print("hi") })
                    SqaureBoxButton(text: "Files", textColor: Color(hex: 0x1AADF8), icon: Image("FolderIcon"), action: { print("hi") })
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

#Preview {
    AddAlbum_Metadata(isNextEnabled: .constant(false))
}

struct SqaureBoxButton: View {
    let text: String
    let textColor: Color
    let icon: Image
    var action: () -> Void

    var body: some View {
        Button(action: action, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("G1"))
                    .frame(height: 64)
                HStack(spacing: 12) {
                    Text(text)
                        .font(Font.custom("Pretendard-SemiBold", size: 18))
                        .foregroundStyle(textColor)
                        .padding(.leading, 16)
                    Spacer()
                    icon
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(.trailing, 12)
                }
            }
        })
    }
}

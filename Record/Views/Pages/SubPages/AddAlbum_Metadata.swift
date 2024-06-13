//
//  AddAlbum_Metadata.swift
//  Record
//
//  Created by nomamac2 on 6/1/24.
//

import PhotosUI
import SwiftData
import SwiftUI

// View Model
@MainActor
class CoverImageModel: ObservableObject {
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }

    enum TransferError: Error {
        case importFailed
    }

    struct CoverImage: Transferable {
        let image: Image

        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
                // Only work when platform can import UIKit
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(uiImage: uiImage)
                return CoverImage(image: image)
            }
        }
    }

    @Published private(set) var imageState: ImageState = .empty

    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }

    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: CoverImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item")
                    return
                }
                switch result {
                case .success(let coverImage?):
                    self.imageState = .success(coverImage.image)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }

    func selectAgain() {
        imageState = .empty
    }
}

// View
struct AddAlbum_Metadata: View {
    @EnvironmentObject var importManager: ImportManager

    @Binding var isNextEnabled: Bool

    @State var title: String = ""

    @State var artists: [Artist] = []

    @State var selectedItems: [PhotosPickerItem] = []

    @StateObject var viewModel = CoverImageModel()

    @State var isGenreSelected: Bool = false

    @Query var genres: [Genre]

    var body: some View {
        ScrollView {
            Spacer()
                .frame(height: 32)

            // MARK: - Title Section

            VStack(spacing: 12) {
                SectionHeader(text: "Title")
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

            // MARK: - Artist Section

            VStack(spacing: 12) {
                SectionHeader(text: "Artist")
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

            // MARK: - Cover Section

            VStack(spacing: 12) {
                SectionHeader(text: "Cover")

                switch viewModel.imageState {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.size.width - 48, height: UIScreen.main.bounds.size.width - 48)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    Button(action: { viewModel.selectAgain() }, label: {
                        HStack(spacing: 12) {
                            RectIconWrapper(icon: Image("Reload"), color: Color("DefaultBlack"), iconWidth: 14, wrapperWidth: 14, wrapperHeight: 14)
                            Text("Select Again")
                                .font(Font.custom("Poppins-Medium", size: 18))
                                .foregroundStyle(Color("DefaultBlack"))
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(Color("G1"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    })
                    .padding(.top, 12)
                case .loading:
                    ProgressView()
                case .empty:
                    HStack {
                        PhotosPicker(selection: $viewModel.imageSelection,
                                     matching: .images)
                        {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color("G1"))
                                    .frame(height: 64)
                                HStack(spacing: 12) {
                                    Text("Photos")
                                        .font(Font.custom("Pretendard-SemiBold", size: 18))
                                        .foregroundStyle(Color("G6"))
                                        .padding(.leading, 16)
                                    Spacer()
                                    Image("PhotosIcon")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .padding(.trailing, 12)
                                }
                            }
                        }

                        SqaureBoxButton(text: "Files", textColor: Color(hex: 0x1AADF8), icon: Image("FolderIcon"), action: { print("hi") })
                    }
                    .padding(.horizontal, 16)
                case .failure:
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
            }
            Spacer()
                .frame(height: 40)

            // MARK: - Genre Area

            VStack {
                SectionHeader(text: "Genre")
                ForEach(genres) { genre in
                    Text("\(genre.name)")
                }
            }

            // MARK: - SubGenre Area

            if isGenreSelected {
                Text("Sub")
            }

            // MARK: - Area for Scroll

            Spacer()
                .frame(height: 128)
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

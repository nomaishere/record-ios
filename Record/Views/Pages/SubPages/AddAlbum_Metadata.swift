//
//  AddAlbum_Metadata.swift
//  Record
//
//  Created by nomamac2 on 6/1/24.
//

import PhotosUI
import SwiftData
import SwiftUI

import SwiftUIFlowLayout

// View
struct AddAlbum_Metadata: View {
    @StateObject var viewModel = CoverImageViewModel()

    @EnvironmentObject var importManager: ImportManager
    @Query var genres: [Genre]
    @Binding var isNextEnabled: Bool

    @State var title: String = ""
    @State var artists: [Artist] = []

    func querySubgenresByIDs(ids: [Genre.ID]) -> [Genre] {
        var tempGenres: [Genre] = []
        for genre in genres {
            for id in ids {
                if id == genre.id {
                    tempGenres.append(genre)
                }
            }
        }
        return tempGenres
    }

    func checkMetadataEditComplete(hasCover: Bool = false) -> Bool {
        if isTitleEditComplete() {
            if isArtistEditComplete() {
                if isCoverEditComplete() || hasCover {
                    return true
                }
            }
        }
        return false
    }

    func isTitleEditComplete() -> Bool {
        if title.isEmpty {
            return false
        } else {
            return true
        }
    }

    func isArtistEditComplete() -> Bool {
        if artists.isEmpty {
            return false
        } else {
            for artist in artists {
                if artist.name.isEmpty {
                    return false
                }
            }
            return true
        }
    }

    func isCoverEditComplete() -> Bool {
        switch viewModel.imageState {
        case .success:
            NSLog("success")
            return true
        case .empty:
            NSLog("empyt")
            return false
        case .loading:
            NSLog("loading")
            return false
        case .failure:
            NSLog("failure")

            return false
        }
    }

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
                    }
                    .padding(.horizontal, 16)
                case .failure:
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
            }
            Spacer.vertical(80)
        }
        .onChange(of: title) {
            isNextEnabled = checkMetadataEditComplete()
        }
        .onChange(of: artists) {
            isNextEnabled = checkMetadataEditComplete()
        }
        .onReceive(viewModel.$imageState) { value in
            switch value {
            case .success:
                isNextEnabled = checkMetadataEditComplete(hasCover: true) // Pass hasCover parameter because viewModel.imageState doesn't update fast as this onReceive modifier.
            case .empty:
                isNextEnabled = checkMetadataEditComplete()
            case .loading:
                isNextEnabled = checkMetadataEditComplete()
            case .failure:
                break
            }
        }
    }
}

#Preview {
    let previewModelContainer: ModelContainer = {
        let schema = Schema([
            Album.self, Artist.self, Track.self, Genre.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])

            // Check application has genre data
            let descriptor = FetchDescriptor<Genre>()
            let existingGenres = try container.mainContext.fetchCount(descriptor)
            guard existingGenres == 0 else { return container }

            // Load built-in genre data & decode
            guard let url = Bundle.main.url(forResource: "BuiltInGenreData", withExtension: "json") else {
                fatalError("Failed to find users.json")
            }

            let data = try Data(contentsOf: url)
            let genreDatas = try JSONDecoder().decode([Genre].self, from: data)

            for genreData in genreDatas {
                container.mainContext.insert(genreData)
            }

            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    return AddAlbum_Metadata(isNextEnabled: .constant(false))
        .modelContainer(previewModelContainer)
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

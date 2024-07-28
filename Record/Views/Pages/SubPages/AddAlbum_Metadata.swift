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
    @Binding var isNextEnabled: Bool

    @State var title: String = ""
    @State var artists: [Artist] = []

    @State var selectedArtist: [Artist] = []

    @Query var savedArtists: [Artist]
    @State var testArtist = [Artist(name: "C418", isGroup: false), Artist(name: "david kim", isGroup: false), Artist(name: "Kendrick Lamar", isGroup: false), Artist(name: "Kanye West", isGroup: false)]

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
            Spacer.vertical(40)

            // MARK: - Artist Section

            VStack(spacing: 0) {
                SectionHeader(text: "Artist")
                Spacer.vertical(12)
                FlowLayout(mode: .scrollable, items: testArtist, itemSpacing: 4) { artist in
                    Text(artist.name)
                        .font(Font.custom("Pretendard-Medium", size: 16))
                        .foregroundStyle(selectedArtist.contains(artist) ? Color(.white) : Color("G7"))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 100)
                                .fill(selectedArtist.contains(artist) ? Color("DefaultBlack") : Color("G1"))
                        )
                        .onTapGesture {
                            if selectedArtist.contains(artist) {
                                if let index = selectedArtist.firstIndex(of: artist) {
                                    withAnimation(.easeIn(duration: 0.2)) {
                                        selectedArtist.remove(at: index)
                                    }
                                }
                            } else {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    selectedArtist.append(artist)
                                }
                            }
                        }
                        .contentShape(Rectangle())
                }
                .padding(.horizontal, 18)
                Spacer.vertical(4)
                HStack {
                    HStack {
                        RectIconWrapper(icon: Image("plus"), color: Color(hex: 0xFF7511), iconWidth: 14, wrapperWidth: 14, wrapperHeight: 14)
                            .padding(.leading, 16)
                        Text("add artist")
                            .font(Font.custom("Pretendard-Medium", size: 16))
                            .foregroundStyle(Color(hex: 0xFF7511))
                            .padding(.trailing, 16)
                            .padding(.vertical, 8)
                    }
                    .background(RoundedRectangle(cornerRadius: 100)
                        .fill(Color("G1")))
                    .onTapGesture {
                        NSLog("hi")
                    }
                    .contentShape(Rectangle())
                    Spacer()
                }
                .padding(.leading, 20)
            }
            Spacer.vertical(40)

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

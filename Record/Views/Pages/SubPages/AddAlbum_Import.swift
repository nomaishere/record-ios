//
//  AddAlbum-Import.swift
//  Record
//
//  Created by nomamac2 on 5/28/24.
//

import SwiftUI

struct AddAlbum_Import: View {
    @State private var showFileImporter = false

    @EnvironmentObject var viewModel: AddAlbumViewModel

    var body: some View {
        ScrollView {
            Spacer.vertical(32)
            VStack(spacing: 12) {
                if !viewModel.selectedFilesURL.isEmpty {
                    HStack(spacing: 0) {
                        Text("\(viewModel.selectedFilesURL.count) Tracks from")
                            .font(Font.custom("Poppins-SemiBold", size: 20))
                            .foregroundStyle(Color("DefaultBlack"))
                        Text(" Files")
                            .font(Font.custom("Poppins-SemiBold", size: 20))
                            .foregroundStyle(Color(hex: 0x1BA5F8))
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    FileListView(fileURLs: viewModel.selectedFilesURL)

                    Spacer()
                } else {
                    HStack {
                        Text("Choose Method")
                            .font(Font.custom("Poppins-SemiBold", size: 20))
                            .foregroundStyle(Color("DefaultBlack"))
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    HStack {
                        Button {
                            showFileImporter = true
                        } label: {
                            VStack {
                                HStack {
                                    Text("Files")
                                        .font(Font.custom("Pretendard-SemiBold", size: 18))
                                        .foregroundStyle(Color(hex: 0x1BA5F8))
                                        .padding(.all, 16)
                                    Spacer()
                                }
                                Spacer()
                                HStack {
                                    Spacer()
                                    Image("FolderIcon")
                                        .padding(.all, 16)
                                }
                            }
                            .frame(width: 172, height: 172)
                            .background(Color("G1"))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.mp3, .wav, .aiff], allowsMultipleSelection: true) { result in
                            switch result {
                            case .success(let urls):

                                for url in urls {
                                    viewModel.selectedFilesURL.append(url)
                                }
                                if !viewModel.selectedFilesURL.isEmpty {
                                    viewModel.isNextEnabled = true
                                }
                            case .failure(let error):
                                print(error)
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)

                    Spacer()
                }
            }
        }
    }
}

struct FileListView: View {
    var fileURLs: [URL]

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(fileURLs, id: \.self) { file in
                    HStack {
                        Text(file.lastPathComponent)
                            .font(Font.custom("Pretendard-SemiBold", size: 18))
                            .foregroundStyle(Color("G6"))
                        Spacer()
                    }
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color("G1"))
                    .frame(minHeight: 1)
            )
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    AddAlbum_Import()
}

#Preview("FileList") {
    FileListView(fileURLs: [URL(string: "test")!, URL(string: "affaaldkwjkldjlkajwldkjalkwjdlkajkwldjlkajkwjdlkwdad")!])
}

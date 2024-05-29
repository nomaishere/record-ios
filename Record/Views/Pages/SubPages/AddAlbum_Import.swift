//
//  AddAlbum-Import.swift
//  Record
//
//  Created by nomamac2 on 5/28/24.
//

import SwiftUI

struct AddAlbum_Import: View {
    
    @State private var showFileImporter = false
    @State private var isAnyFileSelected = false
    
    var body: some View {
        Spacer()
            .frame(height: 32)
        VStack(spacing: 12) {
            if isAnyFileSelected {
                Text("hi")
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
                    .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.mp3, .wav, .aiff, ], allowsMultipleSelection: true) {result in
                        switch result {
                        case .success(let files):
                            isAnyFileSelected = true
                        case .failure(let error):
                            print(error)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
        }
        
    }
}

#Preview {
    AddAlbum_Import()
}

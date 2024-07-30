//
//  AddAlbum_Check.swift
//  Record
//
//  Created by nomamac2 on 6/1/24.
//

import SwiftUI

struct AddAlbum_Check: View {
    @EnvironmentObject var viewModel: AddAlbumViewModel

    var body: some View {
        Text(viewModel.title)
        Text(viewModel.artwork.absoluteString)
    }
}

#Preview {
    AddAlbum_Check()
}

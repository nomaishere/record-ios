//
//  AddAlbum-Import.swift
//  Record
//
//  Created by nomamac2 on 5/28/24.
//

import SwiftUI

struct AddAlbum_Import: View {
    var body: some View {
        Spacer()
            .frame(height: 32)
        VStack(spacing: 12) {
            HStack {
                Text("Choose Method")
                    .font(Font.custom("Poppins-SemiBold", size: 20))
                    .foregroundStyle(Color("DefaultBlack"))
                Spacer()
            }
            .padding(.horizontal, 24)
            HStack {
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
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        
    }
}

#Preview {
    AddAlbum_Import()
}

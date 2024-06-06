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
    
    @FocusState private var isFocused: Bool

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
                    .focused($isFocused)
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
            
        }
        .padding(.vertical, -8)

    }
}



#Preview {
    AddAlbum_Metadata(isNextEnabled: .constant(false))
}

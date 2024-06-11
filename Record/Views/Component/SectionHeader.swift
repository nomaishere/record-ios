//
//  SectionHeader.swift
//  Record
//
//  Created by nomamac2 on 6/11/24.
//

import SwiftUI

struct SectionHeader: View {
    let text: String

    var body: some View {
        HStack {
            Text(text)
                .font(Font.custom("Poppins-SemiBold", size: 20))
                .foregroundStyle(Color("DefaultBlack"))
                .padding(.leading, 24)
            Spacer()
        }
    }
}

#Preview {
    SectionHeader(text: "heading")
}

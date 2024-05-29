//
//  More.swift
//  Record
//
//  Created by nomamac2 on 5/26/24.
//

import SwiftUI

struct More: View {
    var body: some View {
        Spacer()
            .frame(height: 24)
        HStack(alignment: .center) {
            Text("MORE")
                .font(Font.custom("ProFont For Powerline", size: 32))
                .foregroundStyle(Color("DefaultBlack"))
            Spacer()
            Button("SETTING", action: {print("create")})
                .padding(.vertical, 4.0)
                .padding(.horizontal, 24)
                .background(Color("DefaultBlack"))
                .font(Font.custom("Poppins-Medium", size: 20)).foregroundStyle(.white)
                .clipShape(Capsule())
        }
        .padding(.horizontal, 24.0)
    }
}

#Preview {
    More()
}

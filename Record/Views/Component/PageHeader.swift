//
//  PageHeader.swift
//  Record
//
//  Created by nomamac2 on 8/5/24.
//

import SwiftUI

struct PageHeader: View {
    @EnvironmentObject var router: Router
    let pageName: String

    var body: some View {
        HStack(spacing: 12) {
            Button {
                self.router.navigateBack()
            } label: {
                Image("LeftChevron")
                    .frame(width: 48, height: 48)
                    .foregroundColor(Color("DefaultBlack"))
                    .background(Color("G1"))
                    .clipShape(Circle())
            }
            Text(self.pageName)
                .font(Font.custom("Poppins-SemiBold", size: 24))
                .foregroundStyle(Color("DefaultBlack"))
            Spacer()
        }
        .padding(.horizontal, 16)
        .navigationBarBackButtonHidden()
    }
}

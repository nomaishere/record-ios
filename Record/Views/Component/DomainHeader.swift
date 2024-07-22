//
//  DomainHeader.swift
//  Record
//
//  Created by nomamac2 on 7/22/24.
//

import SwiftUI

struct DomainHeader: View {
    let domainName: String
    let handler: () -> Void
    let actionButtonText: String

    var body: some View {
        HStack(alignment: .center) {
            Text(domainName)
                .font(Font.custom("ProFont For Powerline", size: 32))
                .foregroundStyle(Color("DefaultBlack"))
            Spacer()
            Button(actionButtonText, action: { handler() })
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
    DomainHeader(domainName: "COLLECTION", handler: { NSLog("hi") }, actionButtonText: "Add")
}

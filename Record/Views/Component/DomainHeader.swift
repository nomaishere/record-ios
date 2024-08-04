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
    let actionButton: Bool
    let actionButtonText: String

    init(domainName: String, handler: @escaping () -> Void, actionButton: Bool = false, actionButtonText: String = "") {
        self.domainName = domainName
        self.handler = handler
        self.actionButton = actionButton
        self.actionButtonText = actionButtonText
    }

    var body: some View {
        HStack(alignment: .center) {
            /*
             Text(domainName)
                 .font(Font.custom("ProFont For Powerline", size: 32))
                 .foregroundStyle(Color("DefaultBlack"))
              */
            Text(domainName)
                .font(Font.custom("Poppins-SemiBold", size: 32))
                .foregroundStyle(Color("DefaultBlack"))
            Spacer()
            if actionButton {
                Button(action: { handler() }, label: {
                    HStack(spacing: 8) {
                        RectIconWrapper(icon: Image("plus-bold"), color: Color("PointOrange"), iconWidth: 14, wrapperWidth: 14, wrapperHeight: 14)
                        Text(actionButtonText)
                            .font(Font.custom("Poppins-SemiBold", size: 18))
                            .foregroundStyle(Color("PointOrange"))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color("G1"))
                    )

                })
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    DomainHeader(domainName: "COLLECTION", handler: { NSLog("hi") }, actionButton: true, actionButtonText: "NEW")
}

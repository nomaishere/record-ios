//
//  SwiftUIView.swift
//  Record
//
//  Created by nomamac2 on 5/27/24.
//

import SwiftUI

struct RectIconWrapper: View {
    var icon: Image
    var color: Color
    var iconWidth: CGFloat
    var wrapperWidth: CGFloat
    var wrapperHeight: CGFloat
    var body: some View {
        ZStack {
            icon
                .renderingMode(.template)
                .resizable()
                .scaledToFill()
                .foregroundColor(color)
            .frame(width: iconWidth, height: 0)
        }
        .frame(width: wrapperWidth, height: wrapperHeight)
    }
}

#Preview {
    RectIconWrapper(icon: Image("Collection"), color: Color("G3"), iconWidth: 20, wrapperWidth: 32, wrapperHeight: 32)
}

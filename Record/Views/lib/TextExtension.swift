//
//  TextExtension.swift
//  Record
//
//  Created by nomamac2 on 8/5/24.
//

import Foundation
import SwiftUI

extension Text {
    func bodyStyle() -> some View {
        self.font(Font.custom("Pretendard-Medium", size: 16))
            .foregroundStyle(Color("DefaultBlack"))
            .multilineTextAlignment(.leading)
    }

    func headerStyle() -> some View {
        self.font(Font.custom("Pretendard-Semibold", size: 18))
            .foregroundStyle(Color("DefaultBlack"))
            .multilineTextAlignment(.leading)
    }
}

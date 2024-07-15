//
//  ColorHexExtension.swift
//  Record
//
//  Created by nomamac2 on 5/28/24.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }

    init(hexString: String, opacity: Double = 1) {
        var rgb: UInt64 = 0xffffff
        Scanner(string: hexString).scanHexInt64(&rgb)

        self.init(
            .sRGB,
            red: Double((rgb >> 16) & 0xff) / 255,
            green: Double((rgb >> 08) & 0xff) / 255,
            blue: Double((rgb >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}

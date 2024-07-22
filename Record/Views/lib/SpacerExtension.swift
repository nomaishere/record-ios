//
//  Spacer.swift
//  Record
//
//  Created by nomamac2 on 7/22/24.
//

import Foundation
import SwiftUI

public extension Spacer {
    static func vertical(_ value: CGFloat) -> some View {
        Spacer()
            .frame(height: value)
    }
}

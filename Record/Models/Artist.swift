//
//  Artist.swift
//  Record
//
//  Created by nomamac2 on 5/24/24.
//

import Foundation
import SwiftData

@Model
final class Artist: Identifiable {
    var id: UUID = UUID()
    var name: String
    var isGroup: Bool
    var member: [Artist]?
    var albums: [Album]?

    init(name: String, isGroup: Bool) {
        self.name = name
        self.isGroup = isGroup
    }
}

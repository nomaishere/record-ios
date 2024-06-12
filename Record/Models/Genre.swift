//
//  Genre.swift
//  Record
//
//  Created by nomamac2 on 6/12/24.
//

import Foundation
import SwiftData

@Model
final class Genre: Identifiable {
    var id: UUID = UUID()
    var name: String
    var isSubgenre: Bool
    /// If isBuiltIn is true, it means this genre data was provided by application's develpers.
    var isBuiltIn: Bool
    @Relationship var subgenre: [Genre]?

    init(id: UUID, name: String, isSubgenre: Bool, isBuiltIn: Bool, subgenre: [Genre]) {
        self.id = id
        self.name = name
        self.isSubgenre = isSubgenre
        self.isBuiltIn = isBuiltIn
        self.subgenre = subgenre
    }
    
}

//
//  Genre.swift
//  Record
//
//  Created by nomamac2 on 6/12/24.
//

import Foundation
import SwiftData

@Model
final class Genre: Identifiable, Codable {
    enum CodingKeys: CodingKey {
        case id
        case name
        case isSubgenre
        case isBuiltIn
        /// subGenreID is an array of genre id
        case subGenreID
    }

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

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try UUID(uuidString: container.decode(String.self, forKey: .id))!
        self.name = try container.decode(String.self, forKey: .name)
        self.isSubgenre = try container.decode(Bool.self, forKey: .isSubgenre)
        self.isBuiltIn = try container.decode(Bool.self, forKey: .isBuiltIn)
        // TODO: decode for subgenre
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(isSubgenre, forKey: .isSubgenre)
        try container.encode(isBuiltIn, forKey: .isBuiltIn)
        try container.encode(subgenre, forKey: .subGenreID)
    }
}

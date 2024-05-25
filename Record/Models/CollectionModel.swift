//
//  Collection.swift
//  Record
//
//  Created by nomamac2 on 5/24/24.
//

import Foundation
import SwiftData

@Model
final class CollectionModel {
    @Relationship var albums: [Album]
    
    init(albums: [Album]) {
        self.albums = albums
    }
}

//
//  AlbumImportManager.swift
//  Record
//
//  Created by nomamac2 on 5/29/24.
//

import Foundation
import SwiftUI


final class ImportManager: ObservableObject {
    
    public enum importSteps: Codable, Hashable {
        case IMPORT
        case TRACKLIST
        case METADATA
        case CHECK
    }
    
    @Published var nowStep: importSteps = .IMPORT

    var selectedFilesURL: [URL] = []
}

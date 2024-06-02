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
    
    // FOR TEST
    @Published var nowStep: importSteps = .TRACKLIST

    var selectedFilesURL: [URL] = []
}

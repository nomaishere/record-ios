//
//  PreviewContainer.swift
//  Record
//
//  Created by nomamac2 on 5/24/24.
//

import Foundation
import SwiftData

struct Preview {
    var previewModelContainer: ModelContainer = {
        let schema = Schema([
            Album.self, Artist.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer for preview: \(error)")
        }
    }()
    
    func addExample(_ examples: [Album]) {
        Task{ @MainActor in
            examples.forEach {example in
                previewModelContainer.mainContext.insert(example)
            }
        }
    }
}

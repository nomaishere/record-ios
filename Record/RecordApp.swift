//
//  RecordApp.swift
//  Record
//
//  Created by nomamac2 on 5/24/24.
//

import SwiftUI
import SwiftData

@main
struct RecordApp: App {
    @ObservedObject var router = Router()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Album.self, Artist.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                    ContentView()
                    .navigationDestination(for: Router.Destination.self) { destination in
                        switch destination {
                        case .home:
                            ContentView()
                        case .addalbum:
                            AddAlbum()
                        }
                    }
            }
            .environmentObject(router)
        }
        .modelContainer(sharedModelContainer)
    }
}

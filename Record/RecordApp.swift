//
//  RecordApp.swift
//  Record
//
//  Created by nomamac2 on 5/24/24.
//

import SwiftData
import SwiftUI

// TODO: Cleanup Code
extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        UIApplication.shared.keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
    }
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    var swiftUiInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

@main
struct RecordApp: App {
    @ObservedObject var router = Router()
    @ObservedObject var audioManager = AudioManager()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Album.self, Artist.self, Track.self, Genre.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])

            // Check application has genre data
            let descriptor = FetchDescriptor<Genre>()
            let existingGenres = try container.mainContext.fetchCount(descriptor)
            if existingGenres == 0 {
                guard let url = Bundle.main.url(forResource: "BuiltInGenreData", withExtension: "json") else {
                    fatalError("Failed to find users.json")
                }

                let data = try Data(contentsOf: url)
                let genreDatas = try JSONDecoder().decode([Genre].self, from: data)

                for genreData in genreDatas {
                    container.mainContext.insert(genreData)
                }
            }

            // Load built-in genre data & decode

            // All Demo Album
            NSLog("start")
            let existingAlbums = try container.mainContext.fetchCount(FetchDescriptor<Album>())
            if existingAlbums == 0 {
                let demoArtist = Artist(name: "C418", isGroup: false)
                let demoTrack: [Track] = DemoDataInjector.sharedInstance.makeDemoTracksOfDemoAlbum(artist: demoArtist)
                let demoAlbum = Album(title: "Minecraft - Volume Alpha", artist: [demoArtist], tracks: demoTrack, artwork: URL(string: "msva_cover.png")!, releaseDate: Date())

                container.mainContext.insert(demoAlbum)
            }

            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }

    }()

    init() {
        DemoDataInjector.sharedInstance.saveDemoAlbumImage()
    }

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
            .environmentObject(audioManager)
            .modelContainer(sharedModelContainer)
        }
    }
}

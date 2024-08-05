//
//  Router.swift
//  Record
//
//  Created by nomamac2 on 5/26/24.
//

import Foundation
import SwiftUI

final class Router: ObservableObject {
    public enum Destination: Codable, Hashable {
        case addalbum
        case home
        case how_to_use
        case delete_artist
    }

    @Published var navPath = NavigationPath()

    func navigate(to destination: Destination) {
        navPath.append(destination)
    }

    func navigateBack() {
        navPath.removeLast()
    }

    func navigationToRoot() {
        navPath.removeLast(navPath.count)
    }
}

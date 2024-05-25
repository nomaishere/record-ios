//
//  ContentView.swift
//  Record
//
//  Created by nomamac2 on 5/24/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State var selectedTab: Tab = .Collection

    var body: some View {
        switch selectedTab {
        case .Collection:
            Collection()
        case .Playlist:
            Playlist()
        case .More:
            More()
        }
        Spacer()
        NavigationBar(selectedTab: $selectedTab)
    }
  
}

#Preview {
    ContentView()
}

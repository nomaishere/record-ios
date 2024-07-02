//
//  NavigationBar.swift
//  Record
//
//  Created by nomamac2 on 5/26/24.
//

import SwiftUI

enum Tab {
    case Collection
    case Playlist
    case More
}

struct NavigationItem: View {
    var icon: Image
    var title: Text
    var iconWidth: CGFloat
    var tab: Tab
    @Binding var selectedTab: Tab

    var body: some View {
        VStack(spacing: 2) {
            RectIconWrapper(icon: icon, color: tab == selectedTab ? Color("G6") : Color("G3"), iconWidth: iconWidth, wrapperWidth: 32, wrapperHeight: 32)
            title
                .font(Font.custom("Pretendard-Semibold", size: 14))
                .foregroundStyle(tab == selectedTab ? Color("G6") : Color("G3"))
        }
        .frame(width: 110)
        .onTapGesture {
            selectedTab = tab
        }
    }
}

struct NavigationBar: View {
    @Binding var selectedTab: Tab

    @Environment(\.safeAreaInsets) private var safeAreaInsets

    var body: some View {
        VStack(spacing: 0) {
            Color("G2")
                .frame(maxHeight: 2)
                .padding(.all, 0)
            HStack(spacing: 15.5) {
                NavigationItem(icon: Image("Collection"), title: Text("Collection"), iconWidth: 22, tab: .Collection, selectedTab: $selectedTab)
                NavigationItem(icon: Image("Playlist"), title: Text("Playlist"), iconWidth: 30, tab: .Playlist, selectedTab: $selectedTab)
                NavigationItem(icon: Image("More"), title: Text("More"), iconWidth: 20, tab: .More, selectedTab: $selectedTab)
            }
            .padding(.top, 6)
        }
        .frame(maxWidth: .infinity, minHeight: safeAreaInsets.bottom + 59, maxHeight: safeAreaInsets.bottom + 59, alignment: .top)
        .background(Color("G1"))
    }
}

//
//  ContentView.swift
//  Record
//
//  Created by nomamac2 on 5/24/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State var selectedTab: Tab = .Collection
    @State var playerBarZIndex: Double = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            DomainView(selectedTab: $selectedTab)

            Player(playerBarZIndex: $playerBarZIndex)
                .ignoresSafeArea()
                .zIndex(playerBarZIndex) // increase this
            NavigationBar(selectedTab: $selectedTab)
        }
    }
}

struct DomainView: View {
    @Binding var selectedTab: Tab

    var body: some View {
        VStack(spacing: 0) {
            switch selectedTab {
            case .Collection:
                Collection()
            case .Playlist:
                Playlist()
            case .More:
                More()
            }
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}

struct Player: View {
    @State private var isDragging: Bool = false
    @State private var doOnceLock: Bool = false
    @State private var testHeight: CGFloat = 64
    @State private var testWidth: CGFloat = UIScreen.main.bounds.size.width - 16
    @State private var bottomPadding: CGFloat = 67

    @Binding var playerBarZIndex: Double

    enum PlayerMode {
        case minibar
        case expanded
    }

    @State private var playerMode: PlayerMode = .minibar

    @State private var isMinibarItemRender: Bool = true

    var drag: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                self.isDragging = true
                if value.translation.height < -30 {
                    if !self.doOnceLock {
                        self.doOnceLock.toggle()
                        withAnimation(.easeOut(duration: 0.25)) {
                            self.testWidth = UIScreen.main.bounds.size.width
                            self.testHeight = UIScreen.main.bounds.size.height
                            self.bottomPadding = 0
                            playerBarZIndex = 1
                            self.isMinibarItemRender.toggle() // Erase Minibar Item
                        } completion: {
                            self.doOnceLock.toggle()
                            self.isMinibarItemRender = false
                        }
                    }
                } else if value.translation.height > 30 {
                    if !self.doOnceLock {
                        self.doOnceLock.toggle()
                        withAnimation(.easeOut(duration: 0.25)) {
                            self.testWidth = UIScreen.main.bounds.size.width - 16
                            self.testHeight = 64
                            self.bottomPadding = 67

                        } completion: {
                            playerBarZIndex = 0
                            self.doOnceLock.toggle()
                            self.isMinibarItemRender = true
                        }
                    }
                }
            }
            .onEnded { _ in self.isDragging = false }
    }

    var body: some View {
        ZStack {
            Image("ugrshigh")
                .resizable()
                .scaledToFill()
            switch playerMode {
            case .minibar:
                if isMinibarItemRender {
                    HStack {
                        Text("Somozu Combat")
                            .font(Font.custom("Poppins-SemiBold", size: 20))
                            .foregroundStyle(Color(.white))
                            .padding(.leading, 12)
                        Spacer()
                        Button(action: {}, label: { RectIconWrapper(icon: Image("Pause"), color: Color(.white), iconWidth: 17, wrapperWidth: 17, wrapperHeight: 20) })
                            .padding(.trailing, 24)
                    }
                }

            case .expanded:
                Text("Hi")
            }
        }
        .frame(width: testWidth, height: testHeight)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .padding(.bottom, bottomPadding)
        .gesture(drag)
    }
}

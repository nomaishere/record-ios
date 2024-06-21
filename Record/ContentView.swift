//
//  ContentView.swift
//  Record
//
//  Created by nomamac2 on 5/24/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    @State var selectedTab: Tab = .Collection

    @State var isPlayerMinimized: Bool = true

    var body: some View {
        ZStack(alignment: .bottom) {
            DomainView(selectedTab: $selectedTab)
                .padding(.top, safeAreaInsets.top)
            PlayerView(isPlayerMinimized: $isPlayerMinimized, bottomPadding: safeAreaInsets.bottom + 59 + 8)
                .zIndex(isPlayerMinimized ? 0 : 1) // increase this

            NavigationBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea()
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

struct PlayerView: View {
    enum PlayerMode {
        case minibar
        case expanded
        case animated
    }

    @Binding var isPlayerMinimized: Bool
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    @State var playerMode: PlayerMode = .minibar

    @State var viewHeight: CGFloat = 64
    @State var viewWidth: CGFloat = UIScreen.main.bounds.size.width - 16
    @State var bottomPadding: CGFloat

    @State var isMinibarItemRender: Bool = true

    @State var isDragging: Bool = false
    @State var doOnceLock: Bool = false

    let minibarBottomPadding: CGFloat

    init(isPlayerMinimized: Binding<Bool>, bottomPadding: CGFloat) {
        _isPlayerMinimized = isPlayerMinimized
        _bottomPadding = State(initialValue: bottomPadding)
        minibarBottomPadding = bottomPadding
    }

    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                self.isDragging = true

                // MARK: - Expand Player (Swipe Up)

                if value.translation.height < -30 {
                    if !self.doOnceLock {
                        self.doOnceLock.toggle()
                        self.playerMode = .animated
                        isPlayerMinimized = false
                        withAnimation(.easeOut(duration: 0.15)) {
                            self.viewWidth = UIScreen.main.bounds.size.width
                            self.viewHeight = UIScreen.main.bounds.size.height
                            self.bottomPadding = 0
                            self.isMinibarItemRender.toggle() // Erase Minibar Item
                        } completion: {
                            self.playerMode = .expanded
                            self.doOnceLock.toggle()
                            self.isMinibarItemRender = false
                        }
                    }

                    // MARK: - Minimize Player (Swipe Down)

                } else if value.translation.height > 30 {
                    if !self.doOnceLock {
                        self.doOnceLock.toggle()
                        self.playerMode = .animated

                        withAnimation(.easeOut(duration: 0.15)) {
                            self.viewWidth = UIScreen.main.bounds.size.width - 16
                            self.viewHeight = 64
                            self.bottomPadding = minibarBottomPadding

                        } completion: {
                            self.playerMode = .minibar
                            self.doOnceLock.toggle()
                            self.isMinibarItemRender = true
                            isPlayerMinimized = true
                        }
                    }
                }
            }
            .onEnded { _ in self.isDragging = false }
    }

    var body: some View {
        ZStack {
            Color.clear
                .background(
                    Image("ugrshigh")
                        .resizable()
                        .scaledToFill())
            switch playerMode {
            case .minibar:
                if isMinibarItemRender {
                    HStack {
                        Text("Somozu Combat")
                            .font(Font.custom("Poppins-SemiBold", size: 20))
                            .foregroundStyle(Color(.white))
                            .padding(.leading, 12)
                        Spacer()
                        Button(action: {
                            AudioManager.sharedInstance.startAudio()
                            AudioManager.sharedInstance.play()
                        }, label: { RectIconWrapper(icon: Image("Pause"), color: Color(.white), iconWidth: 17, wrapperWidth: 17, wrapperHeight: 20) })
                            .padding(.trailing, 24)
                    }
                }

            case .expanded:
                Text("Hi")
            case .animated:
                Text("ss")
            }
        }
        .frame(width: viewWidth, height: viewHeight)
        // .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .padding(.bottom, bottomPadding)
        .gesture(dragGesture)
    }
}

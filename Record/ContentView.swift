//
//  ContentView.swift
//  Record
//
//  Created by nomamac2 on 5/24/24.
//

import MediaPlayer
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    @State var selectedTab: Tab = .Collection
    @State var isPlayerMinimized: Bool = true

    var body: some View {
        ZStack(alignment: .bottom) {
            DomainView(selectedTab: $selectedTab)
                .padding(.top, safeAreaInsets.top) // Top Safe Area
                .padding(.bottom, safeAreaInsets.bottom + 59) // Bottom Navigation Bar
            PlayerView(safeAreaInsetBottom: safeAreaInsets.bottom, playerMode: .vanished)
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

struct ContentView_Preview: PreviewProvider {
    static let audioManager = AudioManager()
    static var previews: some View {
        ContentView()
            .environmentObject(audioManager)
    }
}

struct PlayerView: View {
    enum PlayerMode {
        case minibar
        case expanded
        case animated
        case vanished
    }

    @EnvironmentObject var audioManager: AudioManager

    @Environment(\.safeAreaInsets) private var safeAreaInsets

    @State var playerMode: PlayerMode

    @State var viewWidth: CGFloat
    @State var viewHeight: CGFloat
    @State var bottomPadding: CGFloat

    @State var isMinibarItemRender: Bool = true

    @State var isDragging: Bool = false
    @State var doOnceLock: Bool = false

    let minibarBottomPadding: CGFloat

    init(safeAreaInsetBottom: CGFloat, playerMode: PlayerMode) {
        minibarBottomPadding = safeAreaInsetBottom + 59 + 8
        _playerMode = State(initialValue: playerMode)

        switch playerMode {
        case .minibar:
            _viewWidth = State(initialValue: UIScreen.main.bounds.size.width - 16)
            _viewHeight = State(initialValue: 64)
            _bottomPadding = State(initialValue: safeAreaInsetBottom + 59 + 8)
        case .expanded:
            _viewWidth = State(initialValue: UIScreen.main.bounds.size.width)
            _viewHeight = State(initialValue: UIScreen.main.bounds.size.height)
            _bottomPadding = State(initialValue: 0)
        case .animated:
            // Error Case
            _viewWidth = State(initialValue: 0)
            _viewHeight = State(initialValue: 0)
            _bottomPadding = State(initialValue: 0)
        case .vanished:
            _viewWidth = State(initialValue: 0)
            _viewHeight = State(initialValue: 0)
            _bottomPadding = State(initialValue: 0)
        }
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
                        }
                    }
                }
            }
            .onEnded { _ in
                NSLog("Drag End")
                self.isDragging = false
            }
    }

    var body: some View {
        ZStack {
            if let nowPlayingTrack = audioManager.nowPlayingTrack {
                Color.clear
                    .background(
                        AsyncImage(url: StorageManager.shared.getActualTrackArtworkURL(nowPlayingTrack)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                            } else if phase.error != nil {
                                Color.red
                            } else {
                                Color.blue
                            }
                        }
                    )
            }

            switch playerMode {
            case .minibar:
                if isMinibarItemRender {
                    HStack {
                        Group {
                            if let nowPlayintTrack = audioManager.nowPlayingTrack {
                                Text("\(nowPlayintTrack.title)")

                            } else {
                                Text("Not Playing")
                            }
                        }
                        .font(Font.custom("Pretendard-SemiBold", size: 20))
                        .foregroundStyle(Color(.white))
                        .padding(.leading, 16)
                        Spacer()
                        switch audioManager.playerState {
                        case .stopped:
                            Color.clear
                        case .playing:
                            Button(action: {
                                audioManager.pause()
                            }, label: { RectIconWrapper(icon: Image("Pause"), color: Color(.white), iconWidth: 17, wrapperWidth: 17, wrapperHeight: 20) })
                                .padding(.trailing, 24)
                        case .paused:
                            Button(action: {
                                audioManager.play()
                            }, label: { RectIconWrapper(icon: Image("Play"), color: Color(.white), iconWidth: 17, wrapperWidth: 17, wrapperHeight: 20) })
                                .padding(.trailing, 24)
                        }
                    }
                }

            case .expanded:
                if let nowPlayingTrack = audioManager.nowPlayingTrack {
                    VStack {
                        Spacer()
                        VStack(spacing: 4) {
                            Text("\(nowPlayingTrack.title)")
                                .font(Font.custom("Pretendard-Bold", size: 20))
                                .foregroundStyle(Color(hexString: nowPlayingTrack.themeColor))
                            ZStack {
                                BackdropBlurView(radius: 16)
                                    .frame(width: 280, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(hex: 0x6F6F6F, opacity: 0.1))
                                    .frame(width: 280, height: 60)
                                HStack(spacing: 0) {
                                    VStack {
                                        Spacer()
                                        HStack(spacing: 0) {
                                            Spacer()
                                            RectIconWrapper(icon: Image("Previous"), color: Color(hexString: nowPlayingTrack.themeColor), iconWidth: 21, wrapperWidth: 21, wrapperHeight: 24)
                                                .padding(.trailing, 32)
                                        }
                                        Spacer()
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        audioManager.previousTrack()
                                    }
                                    Spacer()
                                    VStack {
                                        Spacer()
                                        switch audioManager.playerState {
                                        case .stopped:
                                            Color.clear
                                        case .playing:
                                            RectIconWrapper(icon: Image("Pause_Thin"), color: Color(hexString: nowPlayingTrack.themeColor), iconWidth: 19.4, wrapperWidth: 20, wrapperHeight: 27)
                                                .padding(.horizontal, 32)
                                        case .paused:
                                            RectIconWrapper(icon: Image("Play"), color: Color(hexString: nowPlayingTrack.themeColor), iconWidth: 20, wrapperWidth: 20, wrapperHeight: 27)
                                                .padding(.horizontal, 32)
                                        }

                                        Spacer()
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        switch audioManager.playerState {
                                        case .stopped:
                                            audioManager.pause()
                                        case .playing:
                                            audioManager.pause()
                                        case .paused:
                                            audioManager.play()
                                        }
                                    }
                                    Spacer()
                                    VStack {
                                        Spacer()
                                        HStack(spacing: 0) {
                                            RectIconWrapper(icon: Image("Next"), color: Color(hexString: nowPlayingTrack.themeColor), iconWidth: 21, wrapperWidth: 21, wrapperHeight: 24)
                                                .padding(.leading, 32)
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        audioManager.nextTrack()
                                    }
                                }
                                .frame(width: 280, height: 60)
                            }
                        }
                        Spacer()
                            .frame(height: 96)
                    }

                } else {
                    Text("Error: nowPlayingTrack is nil")
                }

            case .animated:
                Color.clear
            case .vanished:
                Color.clear
                    .onReceive(audioManager.$playerState) { state in
                        if state == .playing {
                            playerMode = .minibar
                            viewWidth = UIScreen.main.bounds.size.width - 16
                            viewHeight = 64
                            withAnimation {
                                bottomPadding = safeAreaInsets.bottom + 59 + 8
                            }
                        } else {}
                    }
            }
        }
        .frame(width: viewWidth, height: viewHeight)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .padding(.bottom, bottomPadding)
        .gesture(dragGesture)
        .contentShape(Rectangle())
        .zIndex(playerMode == .expanded || playerMode == .animated ? 1 : 0)
    }
}

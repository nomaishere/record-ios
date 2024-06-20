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

    @StateObject var viewModel = PlayerViewModel()

    var body: some View {
        ZStack(alignment: .bottom) {
            DomainView(selectedTab: $selectedTab)
                .padding(.top, safeAreaInsets.top)
            PlayerView()
                .environmentObject(viewModel)
                .zIndex(viewModel.playerMode == .minibar ? 0 : 1) // increase this

            NavigationBar(selectedTab: $selectedTab)

            // .ignoresSafeArea()
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
    /*
     @State private var isDragging: Bool = false
     @State private var doOnceLock: Bool = false
     @State private var testHeight: CGFloat = 64
     @State private var testWidth: CGFloat = UIScreen.main.bounds.size.width - 16
     @State private var bottomPadding: CGFloat = 67
     */

    @EnvironmentObject var viewModel: PlayerViewModel

    var body: some View {
        ZStack {
            Color.clear
                .background(
                    Image("ugrshigh")
                        .resizable()
                        .scaledToFill())
            switch viewModel.playerMode {
            case .minibar:
                if viewModel.isMinibarItemRender {
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
        .frame(width: viewModel.viewWidth, height: viewModel.viewHeight)
        // .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .padding(.bottom, viewModel.bottomPadding)
        .gesture(viewModel.dragGesture)
    }
}

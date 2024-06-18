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

    var body: some View {
        ZStack(alignment: .bottom) {
            DomainView(selectedTab: $selectedTab)
            MiniPlayerBar()
                .zIndex(0) // increase this
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

struct MiniPlayerBar: View {
    @State private var isDragging = false

    var drag: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                self.isDragging = true
                if value.translation.height < -30 {
                    print("hi")
                }
            }
            .onEnded { _ in self.isDragging = false }
    }

    var body: some View {
        ZStack {
            Image("modm")
                .resizable()
                .scaledToFill()
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
        .frame(height: 64)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .padding(.horizontal, 8)
        .padding(.bottom, 59 + 8)
        .gesture(drag)
    }
}

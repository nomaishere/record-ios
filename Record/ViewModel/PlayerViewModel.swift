//
//  PlayerViewModel.swift
//  Record
//
//  Created by nomamac2 on 6/20/24.
//

import Foundation
import SwiftUI

class PlayerViewModel: ObservableObject {
    enum PlayerMode {
        case minibar
        case expanded
        case animated
    }

    @Published var playerMode: PlayerMode = .minibar

    @Published var isDragging: Bool = false
    @Published var doOnceLock: Bool = false
    @Published var viewHeight: CGFloat = 64
    @Published var viewWidth: CGFloat = UIScreen.main.bounds.size.width - 16
    @Published var bottomPadding: CGFloat = 59

    @Published var isMinibarItemRender: Bool = true

    // @Binding var playerBarZIndex: Double

    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                self.isDragging = true
                if value.translation.height < -30 {
                    if !self.doOnceLock {
                        self.doOnceLock.toggle()
                        self.playerMode = .animated
                        withAnimation(.easeOut(duration: 3)) {
                            self.viewWidth = UIScreen.main.bounds.size.width
                            self.viewHeight = UIScreen.main.bounds.size.height
                            // self.viewHeight = 300
                            self.bottomPadding = 0
                            self.isMinibarItemRender.toggle() // Erase Minibar Item
                        } completion: {
                            self.playerMode = .expanded
                            self.doOnceLock.toggle()
                            self.isMinibarItemRender = false
                        }
                    }
                } else if value.translation.height > 30 {
                    if !self.doOnceLock {
                        self.doOnceLock.toggle()
                        withAnimation(.easeOut(duration: 3)) {
                            self.viewWidth = UIScreen.main.bounds.size.width - 16
                            self.viewHeight = 64
                            self.bottomPadding = 67

                        } completion: {
                            // playerBarZIndex = 0
                            self.doOnceLock.toggle()
                            self.isMinibarItemRender = true
                        }
                    }
                }
            }
            .onEnded { _ in self.isDragging = false }
    }
}

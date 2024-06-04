//
//  ReorderableForEach.swift
//  Record
//
//  Created by nomamac2 on 6/3/24.
//

import SwiftUI

public typealias Reorderable = Identifiable & Equatable & Hashable

struct GridData: Identifiable, Equatable, Hashable {
    let id: Int
}


/// Reordeable List using onDrag function
/// Originated by Daniel Saidi. check: https://danielsaidi.com/blog/2023/08/30/enabling-drag-reordering-in-swiftui-lazy-grids-and-stacks
struct ReorderableForEach<Item: Reorderable, Content: View, Preview: View>: View {
    public init(
        _ items: [Item],
        active: Binding<Item?>,
        @ViewBuilder content: @escaping (Item) -> Content,
        @ViewBuilder preview: @escaping (Item) -> Preview,
        moveAction: @escaping (IndexSet, Int) -> Void
    ) {
        self.items = items
        self._active = active
        self.content = content
        self.preview = preview
        self.moveAction = moveAction
    }
    
    public init(
        _ items: [Item],
        active: Binding<Item?>,
        @ViewBuilder content: @escaping (Item) -> Content,
        moveAction: @escaping (IndexSet, Int) -> Void
    ) where Preview == EmptyView {
        self.items = items
        self._active = active
        self.content = content
        self.preview = nil
        self.moveAction = moveAction
    }
    
    @Binding private var active: Item?
    @State private var hasChangedLocation = false
    private let items: [Item]
    private let content: (Item) -> Content
    private let preview: ((Item) -> Preview)?
    private let moveAction: (IndexSet, Int) -> Void
    
    var body: some View {
        ForEach(items) { item in
            if let preview {
                contentView(for: item)
                    .onDrag {
                        dragData(for: item)
                    } preview: {
                        preview(item)
                    }
            } else {
                contentView(for: item)
                    .onDrag {
                        dragData(for: item)
                    }
            }
        }
    }
    
    private func contentView(for item: Item) -> some View {
        content(item)
            .opacity(active == item && hasChangedLocation ? 0.5 : 1)
            .onDrop(
                of: [.text],
                delegate: ReorderableDragRelocateDelegate(
                    item: item,
                    items: items,
                    active: $active,
                    hasChangedLocation: $hasChangedLocation
                ) { from, to in
                    withAnimation {
                        moveAction(from, to)
                    }
                }
            )
    }
    
    private func dragData(for item: Item) -> NSItemProvider {
        active = item
        return NSItemProvider(object: "\(item.id)" as NSString)
    }
}

struct ReorderableDragRelocateDelegate<Item: Reorderable>: DropDelegate {
    let item: Item
    var items: [Item]
    
    @Binding var active: Item?
    @Binding var hasChangedLocation: Bool
    
    var moveAction: (IndexSet, Int) -> Void
    
    func dropEntered(info: DropInfo) {
        print("entered!")
        guard item != active, let current = active else { return }
        guard let from  = items.firstIndex(of: current) else { return }
        guard let to = items.firstIndex(of: item) else { return }
        hasChangedLocation = true
        if items[to] != current {
            moveAction(IndexSet(integer: from), to > from ? to + 1 : to)
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        hasChangedLocation = false
        active = nil
        return true
    }
}

struct ReorderableDropOutsideDelegate<Item: Reorderable>: DropDelegate {
    
    @Binding
    var active: Item?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        //print("out of scrollview!")
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        active = nil
        return true
    }
}

public extension View {
    
    func reorderableForEachContainer<Item: Reorderable>(
        active: Binding<Item?>
    ) -> some View {
        onDrop(of: [.text], delegate: ReorderableDropOutsideDelegate(active: active))
    }
}




// V2

class CustomDragEntryObserver<Item: Reorderable>: Observable {
    
    private var targetFrames: [Item: CGRect] = [:]
    
    func update(frame: CGRect, for index: Item) {
        targetFrames[index] = frame
    }
}


struct AdvancedReorderableForEach<Item: Reorderable, Content: View, Preview: View>: View {
    public init(
        _ items: [Item],
        active: Binding<Item?>,
        isScrollDisabled: Binding<Bool>,
        @ViewBuilder content: @escaping (Item) -> Content,
        @ViewBuilder preview: @escaping (Item) -> Preview,
        moveAction: @escaping (IndexSet, Int) -> Void
    ) {
        self.items = items
        self._active = active
        self._isScrollDisabled = isScrollDisabled
        self.content = content
        self.preview = preview
        self.moveAction = moveAction
    }
    
    public init(
        _ items: [Item],
        active: Binding<Item?>,
        isScrollDisabled: Binding<Bool>,
        @ViewBuilder content: @escaping (Item) -> Content,
        moveAction: @escaping (IndexSet, Int) -> Void
    ) where Preview == EmptyView {
        self.items = items
        self._active = active
        self._isScrollDisabled = isScrollDisabled
        self.content = content
        self.preview = nil
        self.moveAction = moveAction
    }
    
    @Binding private var active: Item?
    @State private var hasChangedLocation = false
    private let items: [Item]
    private let content: (Item) -> Content
    private let preview: ((Item) -> Preview)?
    private let moveAction: (IndexSet, Int) -> Void

    @Binding private var isScrollDisabled: Bool
    
    let customCoordinateSpace = "CoordinateSpace"
    @State private var targetFrames: [Item: CGRect] = [:]
    
    /// set true to lock doonce
    @State private var doOnceLock: Bool = false
    @State private var isDraggingNow: Bool = false
    
    @State private var tempLocation: Double = 0
    
    var drag: some Gesture {
        DragGesture()
            .onChanged{ gesture in
                //print("\(gesture.location.y)")
                isScrollDisabled = true
                
                if(!doOnceLock) {
                    if(gesture.location.y >= gesture.startLocation.y + 50) {
                        doOnceLock = true
                        print("move 1->2")
                        withAnimation {
                            moveAction(IndexSet(integer: 4), 0)
                        }
                    }
                }
            }
            .onEnded { gesture in
                doOnceLock = false
                print("ended!")
                isScrollDisabled = false
            }
    }
    
    var body: some View {
        ForEach(items) { item in
            contentView(for: item)
        }
    }
    
    var axisGap:CGFloat = 44 + 18 // Height of item + Height of padding
    
    private func contentView(for item: Item) -> some View {
        HStack {
            content(item)
            Spacer()
            Image("More")
                .frame(width: 16, height: 0)
                .padding(.trailing, 23)
                .gesture(
                    DragGesture()
                        .onChanged{ gesture in
                            print(gesture.location.y)
                            if (isDraggingNow == false) {
                                isDraggingNow = true
                                tempLocation = gesture.startLocation.y
                                isScrollDisabled = true
                            }
                            guard let selectedItemIndex  = items.firstIndex(of: item) else { return }
                            if(!doOnceLock) {
                                if(gesture.location.y >= 0 + axisGap) {
                                    doOnceLock = true
                                    tempLocation = gesture.location.y
                                    withAnimation(.easeInOut(duration: 0.01)) {
                                        moveAction(IndexSet(integer: selectedItemIndex), selectedItemIndex+2)
                                    } completion: {
                                        doOnceLock = false
                                    }
                                } else if (gesture.location.y <= 0 - axisGap) {
                                    doOnceLock = true
                                    tempLocation = gesture.location.y
                                    withAnimation(.easeInOut(duration: 0.01)) {
                                        moveAction(IndexSet(integer: selectedItemIndex), selectedItemIndex-1)
                                    } completion: {
                                        doOnceLock = false
                                    }
                                }
                            }
                        }
                        .onEnded { gesture in
                            isDraggingNow = false
                            doOnceLock = false
                            print("ended!")
                            isScrollDisabled = false
                        }
                )
        }
    }
}

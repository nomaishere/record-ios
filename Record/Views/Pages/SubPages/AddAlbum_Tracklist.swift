//
//  AddAlbum_Tracklist.swift
//  Record
//
//  Created by nomamac2 on 6/1/24.
//

import SwiftUI

struct AddAlbum_Tracklist: View {
    @EnvironmentObject var importManager: ImportManager

    @State var testString = ["Wesley's Theory", "For Free", "King Kunta", "Institutionalized", "These Walls", "u", "Alright", "For Sale?", "Momma", "Hood Politics", "How Much A Dollar Cost", "Complexion (A Zulu Love)", "The Blacker The Berry", "You Ain't Gotta Lie (Momma Said)", "i", "Mortal Man"]
    
    @State var draggedItemVOffset: CGFloat = 0
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                print(value.translation.height)
                draggedItemVOffset = value.translation.height
            }
            .onEnded { value in
                print("Destination: \(value.translation.height))")
            }
    }
    
    @State
    private var items = (1...100).map { GridData(id: $0) }
       
    @State
    private var active: GridData?
    
    var body: some View {
        Spacer()
            .frame(height: 32)
        /*/
        List {
            ForEach(testString, id: \.self) { track in
                Text(track)
                    .listRowSeparator(.hidden)
            }
            .onMove(perform: move)
        }
        .listStyle(PlainListStyle())
        .frame(height: 500)
         */
        
        /*
        List {
            Section() {
                Text("hi")
                    .listRowSeparator(.hidden)
            }
            ForEach(testString, id: \.self) { track in
                HStack {
                    Text(track)
                    Spacer()
                    Image("More")
                        .gesture(drag)
                        .padding(.trailing, 16)
                }
                .frame( height: 44)
                .background(.green)
                .listRowSeparator(.hidden)
                .listRowInsets(.init())
            }
            .onMove(perform: move)
        }
        .listStyle(PlainListStyle())
        .listRowSpacing(10)
        .listSectionSpacing(0)
        .environment(\.editMode, .constant(.active))
        */
        //CustomReorderableList()
        ScrollView(.vertical) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 200))]) {
                ReorderableForEach(items, active: $active) { item in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white.opacity(0.5))
                        .frame(height: 100)
                        .overlay(Text("\(item.id)"))
                        .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 20))
                } preview: { item in
                    Color.white
                        .frame(height: 150)
                        .frame(minWidth: 250)
                        .overlay(Text("\(item.id)"))
                        .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 20))
                } moveAction: { from, to in
                    items.move(fromOffsets: from, toOffset: to)
                }
            }.padding()
        }
        .background(Color.blue.gradient)
        .scrollContentBackground(.hidden)
        .reorderableForEachContainer(active: $active)
        Text("bye")
    }
    
    func move(from source: IndexSet, to destination: Int) {
        testString.move(fromOffsets: source, toOffset: destination)
    }
}

public typealias Reorderable = Identifiable & Equatable

struct GridData: Identifiable, Equatable {
    let id: Int
}

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
        DropProposal(operation: .move)
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


#Preview {
    AddAlbum_Tracklist()
}

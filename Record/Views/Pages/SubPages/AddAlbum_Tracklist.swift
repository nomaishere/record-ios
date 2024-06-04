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
    
    @State
    private var items = (1...100).map { GridData(id: $0) }
       
    @State
    private var active: GridData?
    
    @State private var isScrollDisabled: Bool = false

    
    var body: some View {
        Spacer()
            .frame(height: 32)
        
        /*
        ScrollViewReader { value in
            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem(.flexible())]) {
                    ReorderableForEach(items, active: $active) { item in
                        Rectangle()
                            .fill(.white.opacity(0.01))
                            .frame(height: 44)
                            .overlay(Text("\(item.id)"))
                            .contentShape(.dragPreview, Rectangle())
                            .mask(Rectangle().frame(height: 30))
                            .focusEffectDisabled(true)
                        
                    } preview: { item in
                        Color.white
                            .opacity(0.01)
                            .frame(width: 0.5, height: 0.5)
                            .focusEffectDisabled(true)
                         
                    }
                    moveAction: { from, to in
                        items.move(fromOffsets: from, toOffset: to)
                    }
                }.padding()
            }
            .scrollContentBackground(.hidden)
        .reorderableForEachContainer(active: $active)
        }
        .focusEffectDisabled(true)
        */
                
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 18) {
                    AdvancedReorderableForEach(items, active: $active, isScrollDisabled: $isScrollDisabled) { item in
                        Rectangle()
                            .fill(.red.opacity(0.5))
                            .frame(height: 44)
                            .overlay(Text("\(item.id)"))
                            .contentShape(.dragPreview, Rectangle())
                            .focusEffectDisabled(true)
                    } preview: { item in
                        Color.white
                            .opacity(0.01)
                            .frame(width: 0.5, height: 0.5)
                            .focusEffectDisabled(true)
                    } moveAction: { from, to in
                        items.move(fromOffsets: from, toOffset: to)
                    }
                }
            }
            .scrollDisabled(isScrollDisabled)
        }
        
        
        
        Text("bye")
    }
    
    func move(from source: IndexSet, to destination: Int) {
        testString.move(fromOffsets: source, toOffset: destination)
    }
}


#Preview {
    AddAlbum_Tracklist()
}

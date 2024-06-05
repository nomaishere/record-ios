//
//  AddAlbum_Tracklist.swift
//  Record
//
//  Created by nomamac2 on 6/1/24.
//

import SwiftUI

struct TrackTempData: Identifiable, Equatable, Hashable {
    let id = UUID()
    var title: String
    var trackNumber: Int
    var fileURL: URL
    var artists: [String] = ["Unknown Artist"] // for test
}

struct AddAlbum_Tracklist: View {
    @EnvironmentObject var importManager: ImportManager

    @State var testString = ["Wesley's Theory", "For Free", "King Kunta", "Institutionalized", "These Walls", "u", "Alright", "For Sale?", "Momma", "Hood Politics", "How Much A Dollar Cost", "Complexion (A Zulu Love)", "The Blacker The Berry", "You Ain't Gotta Lie (Momma Said)", "i", "Mortal Man"]
    
    /// Only for development
    /*
    @State private var items = (1...100).map { GridData(id: $0) }
    @State private var active: GridData?
     */
    @State private var active: TrackTempData?

    
    @State private var trackTempDatas: [TrackTempData]
    
    @State private var isScrollDisabled: Bool = false
    
    var numberFormatter = NumberFormatter()

    init(trackTempDatas: [TrackTempData]) {
        _trackTempDatas = State(initialValue: trackTempDatas)
        numberFormatter.minimumIntegerDigits = 2
    }

    
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
       
        /*
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 18) {
                    AdvancedReorderableForEach(trackTempDatas, active: $active, isScrollDisabled: $isScrollDisabled) { track in
                        Rectangle()
                            .fill(.red.opacity(0.5))
                            .frame(height: 44)
                            .overlay(Text("\(track.title)"))
                            .contentShape(.dragPreview, Rectangle())
                            .focusEffectDisabled(true)
                    } preview: { item in
                        Color.white
                            .opacity(0.01)
                            .frame(width: 0.5, height: 0.5)
                            .focusEffectDisabled(true)
                    } moveAction: { from, to in
                        trackTempDatas.move(fromOffsets: from, toOffset: to)
                    }
                }
            }
            .scrollDisabled(isScrollDisabled)
        }
         */
        
        ScrollViewReader { value in
            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 18) {
                    ReorderableForEach(trackTempDatas, active: $active) { track in
                        
                        Rectangle()
                            .fill(.clear)
                            .frame(height: 44)
                            .overlay(HStack(spacing: 0) {
                                VStack {
                                    Text(numberFormatter.string(from: track.trackNumber as NSNumber)!)
                                        .font(Font.custom("Pretendard-SemiBold", size: 18))
                                        .foregroundStyle(Color("G3"))
                                        .padding(.trailing, 12)
                                        .frame(width:52, alignment: .trailing)
                                    Spacer()
                                }
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(track.title)
                                        .font(Font.custom("Pretendard-SemiBold", size: 18))
                                        .foregroundStyle(Color("DefaultBlack"))
                                    Text(track.artists.joined(separator: ", "))
                                        .font(Font.custom("Pretendard-Medium", size: 16))
                                        .foregroundStyle(Color("G3"))
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                RectIconWrapper(icon: Image("More"), color: Color("G3"), iconWidth: 16, wrapperWidth: 44, wrapperHeight: 44)
                            })
                            .contentShape(.dragPreview, Rectangle())
                        
                    } preview: { track in
                        Color.white
                            .opacity(0.01)
                            .frame(width: 0.5, height: 0.5)
                         
                    }
                    moveAction: { from, to in
                        trackTempDatas.move(fromOffsets: from, toOffset: to)
                        // Stupid Method. Need to change
                        for (index, _) in trackTempDatas.enumerated() {
                            trackTempDatas[index].trackNumber = index+1
                        }
                        
                    }
                }
            }
            .scrollContentBackground(.hidden)
        .reorderableForEachContainer(active: $active)
        }
        
        
    }
    
    func move(from source: IndexSet, to destination: Int) {
        testString.move(fromOffsets: source, toOffset: destination)
    }
}



#Preview {
    AddAlbum_Tracklist(trackTempDatas: [TrackTempData(title: "Wesley’s Theory", trackNumber: 1, fileURL: URL(string: "hi")!, artists: ["Kendrick Lamar", "George Clinton", "Thundercat"])])
}

#Preview("2") {
    AddAlbum_Tracklist(trackTempDatas: [TrackTempData(title: "Wesley’s Theory", trackNumber: 1, fileURL: URL(string: "hi")!, artists: ["Kendrick Lamar"])])
}


/*
 struct ContentView_Preview: PreviewProvider {
     static let importManager = ImportManager()
     
     static var previews: some View {
         AddAlbum_Tracklist()
             .environmentObject(importManager)
     }
 }

 */

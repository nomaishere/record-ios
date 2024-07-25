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

    @State private var active: TrackTempData?
    @State private var trackTempDatas: [TrackTempData]
    @State private var isScrollDisabled: Bool = false

    var numberFormatter = NumberFormatter()

    init(trackTempDatas: [TrackTempData]) {
        _trackTempDatas = State(initialValue: trackTempDatas)
        numberFormatter.minimumIntegerDigits = 2
    }

    var body: some View {
        List {
            ForEach(trackTempDatas, id: \.self) { track in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundStyle(Color(hex: 0xF8F8F8, opacity: 0.6))
                    HStack {
                        Text(numberFormatter.string(from: track.trackNumber as NSNumber)!)
                            .font(Font.custom("Pretendard-SemiBold", size: 18))
                            .foregroundStyle(Color("G5"))
                            .padding(.trailing, 8)
                            .monospacedDigit()
                        Text("\(track.title)")
                            .font(Font.custom("Pretendard-SemiBold", size: 18))
                            .foregroundStyle(Color("DefaultBlack"))

                        Spacer()
                        RectIconWrapper(icon: Image("More"), color: Color("G3"), iconWidth: 16, wrapperWidth: 16, wrapperHeight: 16)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 18)
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .listRowSeparator(.hidden)
            }
            .onMove(perform: { from, to in
                NSLog("from: \(from), to: \(to)")
                trackTempDatas.move(fromOffsets: from, toOffset: to)
                for (index, _) in trackTempDatas.enumerated() {
                    trackTempDatas[index].trackNumber = index + 1
                }
            })
        }
        .listStyle(.plain)
        .environment(\.defaultMinListRowHeight, 0)
    }
}

#Preview {
    AddAlbum_Tracklist(trackTempDatas: [TrackTempData(title: "Wesley’s Theory", trackNumber: 1, fileURL: URL(string: "hi")!, artists: ["Kendrick Lamar", "George Clinton", "Thundercat"]), TrackTempData(title: "This is super long text that over the screen", trackNumber: 2, fileURL: URL(string: "hi")!, artists: ["Kendrick Lamar", "George Clinton", "Thundercat"]), TrackTempData(title: "Song 2", trackNumber: 3, fileURL: URL(string: "hi")!, artists: ["Kendrick Lamar", "George Clinton", "Thundercat"])])
}

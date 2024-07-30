//
//  AddAlbum_Tracklist.swift
//  Record
//
//  Created by nomamac2 on 6/1/24.
//

import SwiftUI

struct AddAlbum_Tracklist: View {
    @EnvironmentObject var viewModel: AddAlbumViewModel

    @State private var selectedIndex: Int? = nil
    @State private var isScrollDisabled: Bool = false

    @FocusState private var isTextFieldFocused: Bool

    var numberFormatter = NumberFormatter()

    init() {
        numberFormatter.minimumIntegerDigits = 2
    }

    var body: some View {
        List {
            Spacer.vertical(8)
            ForEach(Array(viewModel.trackMetadatas.enumerated()), id: \.offset) { index, track in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundStyle(index == selectedIndex ? Color("G2") : Color(hex: 0xF8F8F8, opacity: 0.6))
                    VStack {
                        HStack {
                            if selectedIndex != index {
                                Text(numberFormatter.string(from: track.trackNumber as NSNumber)!)
                                    .font(Font.custom("Pretendard-SemiBold", size: 18))
                                    .foregroundStyle(Color("G5"))
                                    .padding(.trailing, 8)
                                    .monospacedDigit()
                            }
                            TextField("", text: $viewModel.trackMetadatas[index].title)
                                .autocorrectionDisabled()
                                .submitLabel(.done)
                                .focused($isTextFieldFocused)
                                .font(Font.custom("Pretendard-SemiBold", size: 18))
                                .foregroundStyle(Color("DefaultBlack"))
                                .onSubmit {
                                    withAnimation(.easeIn(duration: 0.2)) {
                                        selectedIndex = nil
                                    }
                                }
                            Spacer()
                            if selectedIndex == index {
                                RectIconWrapper(icon: Image("circle-check-solid"), color: Color("G7"), iconWidth: 20, wrapperWidth: 20, wrapperHeight: 20)
                                    .onTapGesture {
                                        isTextFieldFocused = false
                                        withAnimation(.easeIn(duration: 0.2)) {
                                            selectedIndex = nil
                                        }
                                    }

                            } else {
                                RectIconWrapper(icon: Image("More"), color: Color("G3"), iconWidth: 16, wrapperWidth: 20, wrapperHeight: 20)
                            }
                        }
                        .onTapGesture {
                            if selectedIndex == index {
                            } else {
                                withAnimation(.easeIn(duration: 0.2)) {
                                    selectedIndex = index
                                }
                            }
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.leading, 18)
                    .padding(.trailing, 12)
                }
                .opacity(index == selectedIndex || selectedIndex == nil ? 1.0 : 0.4)
                .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .listRowSeparator(.hidden)
            }
            .onMove(perform: { from, to in
                NSLog("from: \(from), to: \(to)")
                viewModel.trackMetadatas.move(fromOffsets: from, toOffset: to)
                for (index, _) in viewModel.trackMetadatas.enumerated() {
                    viewModel.trackMetadatas[index].trackNumber = index + 1
                }
            })
        }
        .listStyle(.plain)
        .environment(\.defaultMinListRowHeight, 0)
    }
}

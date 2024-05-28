//
//  ProgressWithText.swift
//  Record
//
//  Created by nomamac2 on 5/28/24.
//


// NOTE: Need to refine code

import SwiftUI



struct ProgressWithText: View {
    var progressBarWidth = UIScreen.main.bounds.size.width - 48
    
    @State var secondItemX: CGFloat = 0
    @State var thirdItemX: CGFloat = 0
    @State var fourthItemX: CGFloat = 0
    
    @State var ProgressBarPosition: CGFloat = 0
    var steps: Int = 0
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(width: progressBarWidth, height: 4)
                    .foregroundStyle(Color("G2"))
                HStack {
                    RoundedRectangle(cornerRadius: 25.0)
                        .frame(width: ProgressBarPosition , height: 4)
                        .foregroundStyle(Color("G6"))
                    Spacer()
                }
                
            }
            .frame(width: progressBarWidth, height: 4, alignment: .leading)
            .padding(.all, 0)
            HStack {
                Text("Import")
                Spacer()
                Text("Tracklist")
                    .background(
                        GeometryReader {geo in
                            Color.clear
                                .preference(key: SecondGeoPreferenceKey.self, value:geo.frame(in: .global).minX )
                        }
                            .onPreferenceChange(SecondGeoPreferenceKey.self) { preferences in
                                self.secondItemX = preferences
                            }
                    )
                Spacer()
                Text("Metadata")
                    .background(
                        GeometryReader {geo in
                            Color.clear
                                .preference(key: ThirdGeoPreferenceKey.self, value:geo.frame(in: .global).minX )
                        }
                            .onPreferenceChange(ThirdGeoPreferenceKey.self) { preferences in
                                self.thirdItemX = preferences
                            }
                    )
                Spacer()
                Text("Check")
                    .background(
                        GeometryReader {geo in
                            Color.clear
                                .preference(key: FourthGeoPreferenceKey.self, value:geo.frame(in: .global).minX )
                        }
                            .onPreferenceChange(FourthGeoPreferenceKey.self) { preferences in
                                self.fourthItemX = preferences
                            }
                    )
            }
            .font(Font.custom("Poppins-Medium", size: 16))
            .foregroundStyle(Color("G3"))
            .padding(.horizontal, 24)
            
            /*
             Button("Previous") {
             withAnimation {
             ProgressBarPosition = secondItemX - 24
             }
             }
             Button("Next") {
             withAnimation {
             ProgressBarPosition = thirdItemX - 24
             }
             }
             */
        }
    }
}

#Preview {
    ProgressWithText()
}


struct SecondGeoPreferenceKey: PreferenceKey {
        typealias Value = CGFloat
        static var defaultValue: Value = 0

        static func reduce(value: inout Value, nextValue: () -> Value) {
            value = nextValue()
        }
}

struct ThirdGeoPreferenceKey: PreferenceKey {
        typealias Value = CGFloat
        static var defaultValue: Value = 0

        static func reduce(value: inout Value, nextValue: () -> Value) {
            value = nextValue()
        }
}

struct FourthGeoPreferenceKey: PreferenceKey {
        typealias Value = CGFloat
        static var defaultValue: Value = 0

        static func reduce(value: inout Value, nextValue: () -> Value) {
            value = nextValue()
        }
}

//
//  ProgressWithText.swift
//  Record
//
//  Created by nomamac2 on 5/28/24.
//


// NOTE: Need to refine code

import SwiftUI

struct Step: Codable, Hashable, Identifiable{
    var id: Int
    var name: String
}



struct ProgressWithText: View {
    let progressBarWidth = UIScreen.main.bounds.size.width - 48
    
    let horizontalPadding: CGFloat = 24
    
    let steps: [Step]

    @State var itemRects: [CGRect]
    
    
    @EnvironmentObject var viewModel: AddAlbumViewModel
    
    /// NOTE: Need to update(remove hard-corded code)
    func makeProgressBarPosition() -> CGFloat {
        switch viewModel.nowStep {
        case .IMPORT:
            return itemRects[0].minX + itemRects[0].width/2 - horizontalPadding
        case .TRACKLIST:
            return itemRects[1].minX + itemRects[1].width/2 - horizontalPadding
        case .METADATA:
            return itemRects[2].minX + itemRects[2].width/2 - horizontalPadding
        case .CHECK:
            return itemRects[3].minX + itemRects[3].width/2 - horizontalPadding
        }
    }
    
    /// NOTE: Need to update(remove hard-corded code)
    func isTextShouldHighlighted(_ selectedStep: Step) -> Bool {
        var tempNowStep: Step
        switch viewModel.nowStep {
        case .IMPORT:
            tempNowStep = Step(id: 1, name: "Import")
        case .TRACKLIST:
            tempNowStep = Step(id: 2, name: "Tracklist")
        case .METADATA:
            tempNowStep = Step(id: 3, name: "Metadata")
        case .CHECK:
            tempNowStep = Step(id: 4, name: "Check")
        }
        
        if(selectedStep.id <= tempNowStep.id) {
            return true
        } else {
            return false
        }
    }
    
    init(steps: [Step]) {
        self.steps = steps
        _itemRects = State(initialValue: [CGRect](repeating: CGRect(), count: steps.count))
    }
    
    var body: some View {
        VStack(spacing: 4) {
            // Bar
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(width: progressBarWidth, height: 4)
                    .foregroundStyle(Color("G2"))
                HStack {
                    RoundedRectangle(cornerRadius: 25.0)
                        .frame(minWidth: 0, maxWidth: abs(makeProgressBarPosition()) , maxHeight: 4)
                        .foregroundStyle(Color("G6"))
                    Spacer()
                }
                
            }
            .frame(width: progressBarWidth, height: 4, alignment: .leading)
            .padding(.all, 0)
            
            // Text
            HStack {
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    Text(step.name)
                        .font(Font.custom("Poppins-Medium", size: 16))
                        .foregroundStyle(isTextShouldHighlighted(step) ? Color("G6") : Color("G3"))
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .preference(key: ItemGeoPreferenceKey.self, value: geo.frame(in: .global))
                            }
                                .onPreferenceChange(ItemGeoPreferenceKey.self) { preferences in
                                    self.itemRects[index] = preferences
                                }
                        )
                    if(index != steps.count-1) {
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, horizontalPadding)
            
           
        }
    }
}

#Preview {
    ProgressWithText(steps: [Step(id: 1, name: "Import"), Step(id: 2, name: "Tracklist"), Step(id: 3, name: "Metadata"), Step(id: 4, name: "Check")])
        .environmentObject(AddAlbumViewModel())
}



struct ItemGeoPreferenceKey: PreferenceKey {
        typealias Value = CGRect
        static var defaultValue: Value = CGRect()

        static func reduce(value: inout Value, nextValue: () -> Value) {
            value = nextValue()
        }
}

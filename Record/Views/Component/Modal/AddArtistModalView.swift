//
//  AddArtistModalView.swift
//  Record
//
//  Created by nomamac2 on 8/5/24.
//

import SwiftUI

struct AddArtistModalView: View {
    @Binding var isModalPresented: Bool
    @State var artistName: String = ""
    @Environment(\.modelContext) private var modelContext
    @State var isAddConditionSatisfied: Bool = false

    var body: some View {
        VStack {
            Spacer.vertical(16)
            HStack {
                Button(action: {
                    self.isModalPresented = false
                }, label: {
                    Text("Cancle")
                        .font(Font.custom("Pretendard-Medium", size: 18))
                        .foregroundStyle(Color("G5"))
                })
                Spacer()
                Button(action: {
                    guard self.isAddConditionSatisfied else { return }

                    let demoArtist = Artist(name: artistName, isGroup: false)
                    self.modelContext.insert(demoArtist)
                    do {
                        try self.modelContext.save()
                    } catch {
                        NSLog("Failed to save")
                    }
                    self.isModalPresented = false
                }, label: {
                    Text("Done")
                        .font(Font.custom("Pretendard-Medium", size: 18))
                        .foregroundStyle(self.isAddConditionSatisfied ? Color("PointOrange") : Color("G2"))
                })
                .onChange(of: artistName) {
                    if artistName.isEmpty {
                        self.isAddConditionSatisfied = false
                    } else {
                        self.isAddConditionSatisfied = true
                    }
                }
            }
            .padding(.horizontal, 16)
            Spacer.vertical(24)
            TextField("Enter name", text: self.$artistName)
                .autocorrectionDisabled()
                .submitLabel(.done)
                .font(Font.custom("Pretendard-SemiBold", size: 18))
                .foregroundStyle(Color("DefaultBlack"))
                .padding(.horizontal, 16)
                .padding(.vertical, 13.5)
                .background(Color("G1"))
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .padding(.horizontal, 16)
                .onAppear {
                    UITextField.appearance().clearButtonMode = .whileEditing
                }
            Spacer()
        }
    }
}

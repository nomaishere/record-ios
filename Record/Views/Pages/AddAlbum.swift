//
//  AddAlbum.swift
//  Record
//
//  Created by nomamac2 on 5/26/24.
//

import SwiftUI

struct AddAlbum: View {
    
    @EnvironmentObject var router: Router
    
    var progressBarWidth = UIScreen.main.bounds.size.width - 48

    var body: some View {
        UnevenRoundedRectangle(cornerRadii: .init(
            topLeading: 0,
            bottomLeading: 40, bottomTrailing: 40, topTrailing: 0), style: .continuous)
        .fill(Color("G1"))
        .strokeBorder(Color("G2") , lineWidth: 2, antialiased: true)
        .border(width: 2, edges: [.top], color: Color("G1"))
        .frame(height: 188, alignment: .top)
        .overlay(
            VStack(spacing: 0) {
                ZStack {
                    HStack {
                        Button() {
                            router.navigateBack()
                        } label: {
                            
                            Image("LeftChevron")
                                .frame(width: 48, height: 48)
                                .foregroundColor(Color("G6"))
                                .background(.white)
                                .clipShape(Circle())
                                .shadow(color: Color("G2"), radius: 8, y: 2)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    Text("Add Album")
                        .font(Font.custom("Poppins-Medium", size: 20))
                        .foregroundStyle(Color("G7"))
                }
                .padding(.bottom, 24)
                ProgressWithText()
                    .padding(.bottom, 24)
                
            }
                .padding(.top, 60)
        , alignment: .top
        )
        .ignoresSafeArea()

        
        Spacer()
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .navigationBarBackButtonHidden()
    }
}



#Preview {
    AddAlbum()
}


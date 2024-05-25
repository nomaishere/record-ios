//
//  Collection.swift
//  Record
//
//  Created by nomamac2 on 5/24/24.
//

import SwiftUI
import SwiftData

struct Collection: View {
    
    @Query var albums: [Album]
    
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
                .frame(height: 24)
            HStack(alignment: .center) {
                Text("COLLECTION")
                    .font(Font.custom("ProFont For Powerline", size: 32))
                    .foregroundStyle(Color("DefaultBlack"))
                Spacer()
                Button("Add", action: {print("Hello, World!")})
                    .padding(.vertical, 4.0)
                    .padding(.horizontal, 24)
                    .background(Color("DefaultBlack"))
                    .font(Font.custom("Poppins-Medium", size: 20)).foregroundStyle(.white)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 24.0)
            Spacer()
                .frame(height: 24)
            HStack {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("G1"))
                        .frame(height: 48)
                    
                    Text("Search")
                        .font(Font.custom("Poppins-Medium", size: 18))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color("G3"))
                        .padding(.leading, 16.0)
                }
                Spacer()
                    .frame(width: 18)
                Button() {
                    print("order")
                } label: {
                    Image("Order")
                        .frame(width: 48, height: 48)
                        .foregroundColor(Color("G3"))
                        .background(Color("G1"))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
            .padding(.horizontal, 16.0)
            Spacer()
                .frame(height: 16)
            AlbumGridList(albums: [Image("tpab")])
        }
    }
}

#Preview {
    Collection()
}

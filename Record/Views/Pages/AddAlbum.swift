//
//  AddAlbum.swift
//  Record
//
//  Created by nomamac2 on 5/26/24.
//

import SwiftUI

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
    
    func strokeBorder(lineWidth: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: lineWidth, edges: edges).foregroundColor(color))
    }
}


struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        edges.map { edge -> Path in
            switch edge {
            case .top: return Path(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))
            case .bottom: return Path(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
            case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            case .trailing: return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }.reduce(into: Path()) { $0.addPath($1) }
    }
}

struct AddAlbum: View {
    
    @EnvironmentObject var router: Router

    var body: some View {
        UnevenRoundedRectangle(cornerRadii: .init(
            topLeading: 0,
            bottomLeading: 40, bottomTrailing: 40, topTrailing: 0), style: .continuous)
        .fill(Color("G1"))
        .strokeBorder(Color("G2") , lineWidth: 2, antialiased: true)
        .border(width: 2, edges: [.top], color: Color("G1"))
        .frame(height: 300, alignment: .top)
        .overlay(
            VStack {
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
                HStack {
                    Text("Import")
                    Text("Tracklist")
                    Text("Metadata")
                    Text("Check")
                }
                .font(Font.custom("Poppins-Medium", size: 16))
                .foregroundStyle(Color("G6"))
                .frame(maxWidth: .infinity)
                
            }
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

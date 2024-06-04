//
//  AddAlbum.swift
//  Record
//
//  Created by nomamac2 on 5/26/24.
//

import SwiftUI

struct AddAlbum: View {
    
    @EnvironmentObject var router: Router
    
    @ObservedObject var importManager = ImportManager()

    
    @State var isNextEnabled: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Color.clear
                .frame(height: 0)
                .background(Color("G1").ignoresSafeArea())
            UnevenRoundedRectangle(cornerRadii: .init(
                topLeading: 0,
                bottomLeading: 40, bottomTrailing: 40, topTrailing: 0), style: .continuous)
            .fill(Color("G1"))
            .strokeBorder(Color("G2") , lineWidth: 2, antialiased: true)
            .border(width: 2, edges: [.top], color: Color("G1"))
            .frame(height: 128, alignment: .top)
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
                , alignment: .top
            )
            .navigationBarBackButtonHidden()
        }
        
        
        Group {
            switch importManager.nowStep {
            case .IMPORT:
                ScrollView() {
                    AddAlbum_Import(isNextEnabled: $isNextEnabled)
                }.padding(.vertical, -8)
            case .TRACKLIST:
                AddAlbum_Tracklist(trackTempDatas: importManager.makeTracktempDatas())
            case .METADATA:
                AddAlbum_Metadata()
            case .CHECK:
                AddAlbum_Check()
            }
            
        }.environmentObject(importManager)
        
        /*
        ScrollView() {
            VStack {
                Group {
                    switch importManager.nowStep {
                    case .IMPORT:
                        AddAlbum_Import(isNextEnabled: $isNextEnabled)
                    case .TRACKLIST:
                        AddAlbum_Tracklist()
                    case .METADATA:
                        AddAlbum_Metadata()
                    case .CHECK:
                        AddAlbum_Check()
                    }
                    
                }.environmentObject(importManager)
                
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, -8)
         */


        
        VStack(spacing: 0) {
            Color("G2")
                .frame(height: 2)
                .padding(.all, 0)
            HStack(spacing: 15.5) {
                Spacer()
                Button("Next Step", action: {
                    if isNextEnabled {
                        if(importManager.nowStep == .IMPORT) {
                            importManager.nowStep = .TRACKLIST
                        }
                            
                    } else {
                        print("bye")
                    }
                })
                    .padding(.vertical, 8.0)
                    .padding(.horizontal, 32.0)
                    .background(isNextEnabled ? Color("DefaultBlack") : Color("G3"))
                    .font(Font.custom("Poppins-Medium", size: 20))
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
            .padding(.top, 14)
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, minHeight: 59, maxHeight: 59, alignment: .top)
        .background(Color("G1"))
    }
}



#Preview {
    AddAlbum()
}


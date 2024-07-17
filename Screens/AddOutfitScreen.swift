//
//  AddOutfitScreen.swift
//  myWardrobe
//
//  Created by Studente on 02/07/24.
//

import SwiftUI

struct AddOutfitScreen: View {
    @State private var isAddShirtScreenActive = false
    @State private var isAddTrousersScreenActive = false
    @State private var isAddShoesScreenActive = false

    var body: some View {
        NavigationStack {
            ScrollView{
                Spacer().frame(height: 50)
                VStack(spacing:60){
                    Button("",systemImage: "tshirt") {
                        isAddShirtScreenActive = true
                        print("maglia")
                    }
                    Button("",systemImage: "plus") {
                        isAddTrousersScreenActive = true
                        print("pantalone")
                    }
                    Button("",systemImage: "shoe") {
                        isAddShoesScreenActive = true
                        print()
                    }
                    
                }.frame(width:150, height: 300,alignment: Alignment.center)
                    .border(Color.black)
                
                
                Spacer().frame(height: 50)
                
                Text("Outfit già composti")
                
                Spacer().frame(height: 20)

                ScrollView(.horizontal){
                    HStack(spacing:20){
                        ForEach(0..<10) {
                            Text("Outfit \($0)")
                                .foregroundStyle(.white)
                                .font(.largeTitle)
                                .frame(width: 200, height: 350)
                                .background(.red)
                        }
                    }
                }
            }
        }
        .navigationTitle("Componi Outfit")
    }
    
}

#Preview {
    AddOutfitScreen()
}

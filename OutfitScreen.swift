//
//  OutfitScreen.swift
//  myWardrobe
//
//  Created by Studente on 02/07/24.
//

import SwiftUI

struct OutfitScreen: View {
    @State private var isAddOutfitScreenActive = false
    @State private var isEditOutfitScreenActive = false
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack{
                    Text("Outfit che non indossi da un po'")
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
                    Spacer().frame(height: 20)
                    Text("Outfit estivi")
                    ScrollView(.horizontal){
                        HStack(spacing:20){
                            ForEach(0..<10) {
                                Text("Outfit \($0)")
                                    .foregroundStyle(.white)
                                    .font(.largeTitle)
                                    .frame(width: 200, height: 350)
                                    .background(.blue)
                            }
                        }
                    }
                    Spacer()
                }
                
                
//                Image("icon")
//                    .resizable()
//                    .frame(width: 80, height: 80)
//                
//                Text("Cambia il tuo stile!")
//                    .fontWeight(.bold)
//                    .font(.system(size: 36))
//                
//                Text("Crea il tuo guardaroba personale.\nTocca il pulsante + per iniziare!")
//                    .multilineTextAlignment(.center)
//                    .font(.system(size: 20))
            }
            .navigationTitle("My Wardrobe")
            .searchable(text: $searchText, isPresented: $searchIsActive, prompt: "Cerca outfit")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        isAddOutfitScreenActive = true
                        print("A")
                    }
                    
                label: {
                    Image(systemName: "plus.circle")
                }
                    Button {
                        isEditOutfitScreenActive = true
                        print("B")
                    }
                label: {
                    Image(systemName: "ellipsis.circle")
                }
                }
            }.navigationDestination(isPresented: $isAddOutfitScreenActive){
                AddOutfitScreen()
            }
            .navigationDestination(isPresented: $isEditOutfitScreenActive){
                EditOutfitScreen()
            }
        }
    }
}
#Preview {
    OutfitScreen()
}

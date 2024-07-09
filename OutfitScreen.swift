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
    @State private var isInfoOutfitScreenActive = false
    @State var stato:String
    
    var nOutfits:Int
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack{
                    Text("Outfit che non indossi da un po'")
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack(spacing:20){
                            ForEach(0..<10) {
                                Button("\($0)",systemImage: "tshirt") {
                                    print("Outfit che non indossi da un po'")
                                    stato = "Outfit che non indossi da un po' numero "
                                    isInfoOutfitScreenActive = true
                                }
                                    .foregroundStyle(.black)
                                    .font(.largeTitle)
                                    .frame(width: 200, height: 350)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(.red, lineWidth: 5)
                                    )
                            }
                        }.padding()
                    }
                    
                    Spacer().frame(height: 20)
                    Text("Outfit estivi")
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack(spacing:20){
                            ForEach(0..<10) {
                                Button("\($0)",systemImage: "tshirt") {
                                    print("Outfit estivo")
                                    stato = "Outfit estivo numero "
                                    isInfoOutfitScreenActive = true
                                }
                                .foregroundStyle(.black)
                                .font(.largeTitle)
                                .frame(width: 200, height: 350)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.blue, lineWidth: 5)
                                )
                            }
                        }.padding()
                    }
                    Spacer()
                }
            }
            .navigationTitle("My Outfits")
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
            .navigationDestination(isPresented: $isInfoOutfitScreenActive){
                InfoOutfitScreen(stato: stato)
            }
        }
    }
}
#Preview {
    OutfitScreen(stato: "prova",nOutfits: 3)
}

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
    @State var stato:Outfit
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    let maglia = Vestito(nomeImmagine: "gucci", tipoVestito: "maglia")
    let pantaloni = Vestito(nomeImmagine: "cargo", tipoVestito:"pantaloni")
    let scarpe = Vestito(nomeImmagine: "balenciaga", tipoVestito: "scarpe")
    
    let maglia_estiva = Vestito(nomeImmagine: "thenorthface", tipoVestito: "maglia")
    let pantaloni_estivi = Vestito(nomeImmagine: "bermuda", tipoVestito: "pantaloni")
    let scarpe_estive = Vestito(nomeImmagine: "vans", tipoVestito: "scarpe")
    
    
    var body: some View {
        let outfit = Outfit(shirt:maglia,trousers:pantaloni,shoes:scarpe)
        let outfit_estivo = Outfit(shirt:maglia_estiva,trousers:pantaloni_estivi,shoes:scarpe_estive)
        NavigationStack {
            ScrollView{
                VStack{
                    Text("Outfit che non indossi da un po'")
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack(spacing:20){
                            ForEach(0..<10) { n in
                                Button("\(n)",systemImage: "tshirt") {
                                    stato = outfit
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
                            ForEach(0..<10) { n in
                                Button("\(n)",systemImage: "tshirt") {
                                    stato = outfit_estivo
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
    OutfitScreen(stato: Outfit(shirt: Vestito(nomeImmagine: " ", tipoVestito: " "), trousers: Vestito(nomeImmagine: " ", tipoVestito: " "), shoes:Vestito(nomeImmagine: " ", tipoVestito: " ")))
}

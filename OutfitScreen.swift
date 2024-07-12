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
    @State var stato:[Outfit]
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    @State var maglia = Vestito(nomeImmagine: "", tipoVestito: "")
    @State var pantaloni = Vestito(nomeImmagine: "", tipoVestito: "")
    @State var scarpe = Vestito(nomeImmagine: "", tipoVestito: "")
        
    @State var maglia_estiva = Vestito(nomeImmagine: "", tipoVestito: "")
    @State var pantaloni_estivi = Vestito(nomeImmagine: "", tipoVestito: "")
    @State var scarpe_estive = Vestito(nomeImmagine: "", tipoVestito: "")
    
    

    
    
    var body: some View {

        @State var outfits:[Outfit] = [Outfit(shirt: maglia, trousers: pantaloni, shoes: scarpe)]

        
        @State var range: Range<Int> = 0..<outfits.count

        NavigationStack {
            ScrollView{
                VStack{
                    Text("Outfit che non indossi da un po'")
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack(spacing:20){
                            ForEach(range, id: \.self) { n in
                                Button("\(n)",systemImage: "tshirt") {
                                    maglia = Vestito(nomeImmagine: "gucci", tipoVestito: "maglia")
                                    pantaloni = Vestito(nomeImmagine: "cargo", tipoVestito:"pantaloni")
                                    scarpe = Vestito(nomeImmagine: "balenciaga", tipoVestito: "scarpe")
                                    
                                    stato = outfits
                                    
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
                            ForEach(range, id: \.self) { n in
                                Button("\(n)",systemImage: "tshirt") {
                                     maglia_estiva = Vestito(nomeImmagine: "thenorthface", tipoVestito: "maglia")
                                     pantaloni_estivi = Vestito(nomeImmagine: "bermuda", tipoVestito: "pantaloni")
                                     scarpe_estive = Vestito(nomeImmagine: "vans", tipoVestito: "scarpe")
                                    
                                    stato = outfits
                                    
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
                InfoOutfitScreen(outfits: outfits)
            }
        }
    }
}
#Preview {
    OutfitScreen(stato:[Outfit(shirt: Vestito(nomeImmagine: "", tipoVestito: ""), trousers: Vestito(nomeImmagine: "", tipoVestito: ""), shoes: Vestito(nomeImmagine: "", tipoVestito: ""))])
}

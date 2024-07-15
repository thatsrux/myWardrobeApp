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
    @State var outfits1 = [Outfit]()
    @State var outfits2 = [Outfit]()
    @State var outfits = [Outfit]()
    @State var range1: Range<Int> = 0..<0
    @State var range2: Range<Int> = 0..<0
    @State var index:Int
    
    @State private var searchText = ""
    @State private var searchIsActive = false

    @State var count1 = 0
    @State var count2 = 0
    init(outfits:[Outfit]){
        // Aggiungere funzione che divide l'array totale degli outfit in un array per ogni tipologia di outfit
        // Da capire perchè State Array non è mai vuoto ma ha [myWardrobe.Outfit(shirt: myWardrobe.Cloth, trousers: myWardrobe.Cloth, shoes: myWardrobe.Cloth)]
        self.outfits1 = outfits
        self.outfits2 = outfits
        self.index = 0
        self.range1 = 0..<self.outfits1.count
        self.range2 = 0..<self.outfits2.count
    }
    
    var body: some View {
        
    NavigationStack {
            ScrollView{
                VStack{
                    Text("Outfit che non indossi da un po'")
                    Button("Aggiungi Outfit ", systemImage: "plus", action: {
                        outfits1.append(Outfit(shirt: Cloth(nome: "gucci \(count1)", categoria: "maglia \(count1)"), trousers: Cloth(nome: "cargo \(count1)", categoria: "pantaloni \(count1)"), shoes: Cloth(nome: "jordan \(count1)", categoria: "scarpe \(count1)")))
                        count1 += 1
                        range1 = 0..<outfits1.count-1
                    })
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack(spacing:20){
                            ForEach(range1, id: \.self) { n in
                                Button("\(n)",systemImage: "tshirt") {
                                    outfits = outfits1
                                    index = n
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
                        }
                        .padding()
                    }
                    
                    Spacer().frame(height: 20)
                    Text("Outfit estivi")
                    Button("Aggiungi outfit estivo", systemImage: "plus", action: {
                        outfits2.append(Outfit(shirt: Cloth(nome: "TheNorthFace \(count2)", categoria: "maglia \(count2)"), trousers: Cloth(nome: "baggy \(count2)", categoria: "pantaloni \(count2)"), shoes: Cloth(nome: "balenciaga \(count2)", categoria: "scarpe \(count2)")))
                        count2 += 1
                        range2 = 0..<outfits2.count-1

                    })
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack(spacing:20){
                            ForEach(range2, id: \.self) { n in
                                Button("\(n)",systemImage: "tshirt") {
                                    outfits = outfits2
                                    index = n
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
                }.onAppear{
                    range1 = 0..<outfits1.count-1
                    range2 = 0..<outfits2.count-1
                }
            }
            .navigationTitle("My Outfits")
            .searchable(text: $searchText, isPresented: $searchIsActive, prompt: "Cerca outfit")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        isAddOutfitScreenActive = true                    }
                    
                label: {
                    Image(systemName: "plus.circle")
                }
                    Button {
                        isEditOutfitScreenActive = true
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
                if outfits.isEmpty == false{
                    InfoOutfitScreen(outfits: outfits,index:index)
                }
                else{
                    InfoOutfitScreen(outfits: outfits1,index:index)
                }
                
            }
        }
    }
}

#Preview {
    OutfitScreen(outfits:[Outfit(shirt: Cloth(nome: "", categoria: ""), trousers: Cloth(nome: "", categoria: ""), shoes: Cloth(nome: "", categoria: ""))])
}


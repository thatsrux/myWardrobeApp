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
    @State var outfits:[Outfit]
    @State var outfits2:[Outfit]
    @State var range1: Range<Int> = 0..<0
    @State var range2: Range<Int> = 0..<0
    @State var index:Int
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    @State var count = 0
    @State var count2 = 0

    init(outfits:[Outfit]){
        // Aggiungere funzione che divide l'array totale degli outfit in un array per ogni tipologia di outfit
        
        self.outfits = outfits
        self.outfits2 = outfits
        self.index = 0
        self.range1 = 0..<self.outfits.count
        self.range2 = 0..<self.outfits2.count
        
        self.outfits.removeFirst()
        self.outfits2.removeAll()
        print("nOutfit1:\(self.outfits.count)\(outfits)")
        print("nOutfit2:\(self.outfits2.count)\(outfits2)")

    }
    
    
    
    
    var body: some View {
        
        
        
        NavigationStack {
            ScrollView{
                VStack{
                    Text("Outfit che non indossi da un po'")
                    Button("Aggiungi Outfit ", systemImage: "plus", action: {
                        outfits.append(Outfit(shirt: Cloth(nome: "prova\(count)", categoria: "prova"), trousers: Cloth(nome: "prova", categoria: "prova"), shoes: Cloth(nome: "prova", categoria: "prova")))
                        count += 1
                        range1 = 0..<outfits.count-1
                    })
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack(spacing:20){
                            ForEach(range1, id: \.self) { n in
                                Button("\(n)",systemImage: "tshirt") {
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
                        outfits2.append(Outfit(shirt: Cloth(nome: "prova\(count)", categoria: "prova"), trousers: Cloth(nome: "prova", categoria: "prova"), shoes: Cloth(nome: "prova", categoria: "prova")))
                        count += 1
                    })
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack(spacing:20){
                            ForEach(range2, id: \.self) { n in
                                Button("\(n)",systemImage: "tshirt") {
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
                        }.onAppear{
                            outfits2.append(Outfit(shirt: Cloth(nome: "prova\(count2)", categoria: "prova"), trousers: Cloth(nome: "prova", categoria: "prova"), shoes: Cloth(nome: "prova", categoria: "prova")))
                            count2 += 1
                        }
                        .padding()
                    }
                    Spacer()
                }.onAppear{
                    range1 = 0..<outfits.count-1
                    range2 = 0..<outfits2.count-1
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
                InfoOutfitScreen(outfits: outfits,index:index)
            }
        }
    }
}
#Preview {
    OutfitScreen(outfits:[Outfit(shirt: Cloth(nome: "", categoria: ""), trousers: Cloth(nome: "", categoria: ""), shoes: Cloth(nome: "", categoria: ""))])
}

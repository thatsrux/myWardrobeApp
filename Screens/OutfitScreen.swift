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
<<<<<<< Updated upstream

    @State var range1: Range<Int> = 0..<0
    @State var range2: Range<Int> = 0..<0

=======
>>>>>>> Stashed changes
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    @State var count1 = 0
    @State var count2 = 0
<<<<<<< Updated upstream
    
    init(){
        
    }
=======

>>>>>>> Stashed changes
    
    
    
    var body: some View {
            NavigationStack {
                    ScrollView{
                        VStack{
                            Text("Outfit che non indossi da un po'")
                            Button("Aggiungi Outfit ", systemImage: "plus", action: {
                                
                            })
                            ScrollView(.horizontal,showsIndicators: false){
                                HStack(spacing:20){
<<<<<<< Updated upstream
                                    ForEach(range1, id: \.self) { n in
                                        Button("\(n)",systemImage: "tshirt") {
                                        }
                                        .foregroundStyle(.black)
                                        .font(.largeTitle)
                                        .frame(width: 200, height: 350)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(.red, lineWidth: 5)
                                        )
                                    }
=======
                                    Text("CIAO")
>>>>>>> Stashed changes
                                }
                                .padding()
                            }
        
                            Spacer().frame(height: 20)
                            Text("Outfit estivi")
                            Button("Aggiungi outfit estivo", systemImage: "plus", action: {
<<<<<<< Updated upstream
=======
                                
>>>>>>> Stashed changes
        
                            })
                            ScrollView(.horizontal,showsIndicators: false){
                                HStack(spacing:20){
<<<<<<< Updated upstream
                                    ForEach(range2, id: \.self) { n in
                                        Button("\(n)",systemImage: "tshirt") {
                                            
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
=======
                                    Text("CIAO2")
>>>>>>> Stashed changes
                                }.padding()
                            }
                            Spacer()
                        }.onAppear{
                            
                        }
                    }
                    .navigationTitle("My Outfits")
                    
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button {
                                isAddOutfitScreenActive = true
                            }
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
                    }
<<<<<<< Updated upstream
=======
                    
>>>>>>> Stashed changes
                    .navigationDestination(isPresented: $isAddOutfitScreenActive){
                        AddOutfitScreen()
                    }
                }
            }
    }
    //
    //#Preview {
    //    OutfitScreen(outfits:[Outfit(shirt: Cloth(nome: "", categoria: ""), trousers: Cloth(nome: "", categoria: ""), shoes: Cloth(nome: "", categoria: ""))])
    //}
    //


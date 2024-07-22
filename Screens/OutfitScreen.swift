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
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    

    
    init(){
        
    }
    
    var body: some View {
            NavigationStack {
                    ScrollView{
                        VStack{
                            Text("Outfit che non indossi da un po'")
                            Button("Aggiungi Outfit ", systemImage: "plus", action: {
                                
                            })
                            ScrollView(.horizontal,showsIndicators: false){
                                HStack(spacing:20){
                                    Text("CIAO")

                                }
                                .padding()
                            }
        
                            Spacer().frame(height: 20)
                            Text("Outfit estivi")
                            
                            ScrollView(.horizontal,showsIndicators: false){
                                HStack(spacing:20){

                                    Text("CIAO2")
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


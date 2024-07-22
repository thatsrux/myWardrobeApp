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
    
    @EnvironmentObject var database:Database
    
    
    
    init(){
        
    }
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack{
                    Text("Outfits")
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack{
                            ForEach(database.outfits, id:\.self){ o in
                                NavigationLink(destination: AddOutfitScreen(outfit: o)) {
                                    HStack{
                                        VStack(spacing:10){
                                            Text(o.shirt?.nome ?? "")
                                            Image(uiImage: o.shirt?.image?.toImage() ?? UIImage(imageLiteralResourceName: "imageNA"))
                                                .resizable()
                                                .scaledToFit()
                                                .clipped()
                                                .frame(width:100,height:100)
                                            Text(o.trousers?.nome ?? "")
                                            Image(uiImage: o.trousers?.image?.toImage() ?? UIImage(imageLiteralResourceName: "imageNA"))
                                                .resizable()
                                                .scaledToFit()
                                                .clipped()
                                                .frame(width:100,height:100)
                                            Text(o.shoes?.nome ?? "")
                                            Image(uiImage: o.shoes?.image?.toImage() ?? UIImage(imageLiteralResourceName: "imageNA"))
                                                .resizable()
                                                .scaledToFit()
                                                .clipped()
                                                .frame(width:100,height:100)
                                        }
                                        
                                    }
                                }
                            }.padding(.trailing,30)
                        }
                        
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
                            database.removeOutfits()
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
}

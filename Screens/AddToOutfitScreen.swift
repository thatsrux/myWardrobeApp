//
//  ClothesScreen.swift
//  myWardrobe
//
//  Created by Studente on 02/07/24.
//

import SwiftUI
import Firebase

struct AddToOutfitScreen: View {
    @State var isPresenting: Bool = false
    @State var uiImage: UIImage?
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    let columns = [
        GridItem(.adaptive(minimum: 160))
    ]
    
    @State private var isInfoClothScreenActive = false
    @State private var isEditClothScreenActive = false
    @State private var returnCloth = false
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    @EnvironmentObject var database:Database
    @Environment(\.dismiss) private var dismiss
    
    var onDismiss: ((_ model: Cloth) -> Void)?
    
    @Binding var category: [Categoria]
    
    @Binding var shirtToAdd:Cloth?
    @Binding var trousersToAdd:Cloth?
    @Binding var shoesToAdd:Cloth?
    
    @State private var selectedOption2 = "AllTypes"
    
    @State private var favouriteActive = false
    
    //    init(category: Categoria) {
    //        self.category = category
    //    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if searchIsActive {
                    if !database.clothes.isEmpty{
                        if favouriteActive{
                            List{
                                ForEach(category, id: \.self){
                                    cat in
                                    ForEach(database.favClothes, id: \.self) { cloth in
                                        if (selectedOption2 == cloth.categoria.rawValue || selectedOption2 == "AllTypes") && (cloth.nome.lowercased().contains(searchText.lowercased()) || searchText == "")
                                            && cloth.categoria == cat {
                                            SingleClothList(cloth: cloth)
                                                .onTapGesture {
                                                    chooseClothType(cloth: cloth)
                                                }
                                        }
                                    }
                                }
                            }
                        }
                        else if selectedOption2 != "AllTypes" {
                            List{
                                ForEach(category, id: \.self){
                                    cat in
                                ForEach(database.clothes, id: \.self) { cloth in
                                    if (selectedOption2 == cloth.categoria.rawValue || selectedOption2 == "AllTypes") && (cloth.nome.lowercased().contains(searchText.lowercased()) || searchText == "")
                                        && cloth.categoria == cat {
                                        SingleClothList(cloth: cloth)
                                            .onTapGesture {
                                                chooseClothType(cloth: cloth)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            List {
                                ForEach(category, id: \.self){
                                    cat in
                                    ForEach(database.clothes) { cloth in
                                        if (cloth.nome.lowercased().contains(searchText.lowercased()) || searchText == "")
                                            && cloth.categoria == cat {
                                            SingleClothList(cloth: cloth)
                                                .onTapGesture {
                                                    chooseClothType(cloth: cloth)
                                                }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else{
                        Text("Inserisci un capo d'abbigliamento")
                    }
                }
                else {
                    if !database.clothes.isEmpty{
                        if favouriteActive{
                            ScrollView{
                                LazyVGrid(columns: columns, spacing: 10) {
                                    ForEach(category, id: \.self){
                                        cat in
                                        ForEach(database.favClothes, id: \.self) { cloth in
                                            if (selectedOption2 == cloth.categoria.rawValue || selectedOption2 == "AllTypes")
                                                && cloth.categoria == cat {
                                                SingleClothGrid(cloth: cloth)
                                                    .onTapGesture {
                                                        chooseClothType(cloth: cloth)
                                                    }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if selectedOption2 != "AllTypes" {
                            ScrollView{
                                LazyVGrid(columns: columns, spacing: 10) {
                                    ForEach(category, id: \.self){
                                        cat in
                                        ForEach(database.clothes) { cloth in
                                            if cloth.categoria == cat && selectedOption2 == cloth.categoria.rawValue {
                                                SingleClothGrid(cloth: cloth)
                                                    .onTapGesture {
                                                        chooseClothType(cloth: cloth)
                                                    }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            ScrollView {
                                LazyVGrid(columns: columns, spacing: 10) {
                                    ForEach(category, id: \.self){
                                        cat in
                                        Section(header: Text(categoriePlurale[Categoria(rawValue: cat.rawValue) ?? .NA]!).font(.headline)){
                                            ForEach(database.clothes) { cloth in
                                                if cloth.categoria == cat {
                                                    SingleClothGrid(cloth: cloth)
                                                        .onTapGesture {
                                                            chooseClothType(cloth: cloth)
                                                        }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else{
                        Text("Inserisci un capo d'abbigliamento")
                    }
                }
            }
                .navigationTitle(
                    category == upperCat ? "Parte superiore" :
                        category == lowerCat ? "Parte inferiore" :
                        "Scarpe"
                )
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            if !favouriteActive {
                                favouriteActive = true
                            } else {
                                favouriteActive = false
                            }
                        } label: {
                            if !favouriteActive {
                                Image(systemName: "star")
                            } else {
                                Image(systemName: "star.fill")
                            }
                        }
                        Menu() {
                            Picker(selection: $selectedOption2, label: Text("Options")) {
                                Text("Tutti i tipi").tag("AllTypes")
                                ForEach(category, id: \.self) { cat in
                                    if cat != .NA {
                                        Text(categoriePlurale[Categoria(rawValue: cat.rawValue) ?? .NA]!).tag(cat.rawValue)
                                    }
                                }
                            }
                        } label:{
                            Text("Tipi")
                        }
                    }
                }
                .searchable(text: $searchText, isPresented: $searchIsActive, prompt: "Cerca capo")
            //            .navigationDestination(isPresented: $returnCloth){
            //                if let clothToAdd = clothToAdd{
            //                    AddOutfitScreen(cloth:clothToAdd)
            //                }
            //                else{
            //
            //                }
            //            }
        }
    }
    func chooseClothType(cloth: Cloth) {
        if upperCat.contains(cloth.categoria) {
            shirtToAdd = cloth
            onDismiss?(shirtToAdd!)
        }
        else if lowerCat.contains(cloth.categoria) {
            trousersToAdd = cloth
            onDismiss?(trousersToAdd!)
        }
        else if shoesCat.contains(cloth.categoria) {
            shoesToAdd = cloth
            onDismiss?(shoesToAdd!)
        }
        
        dismiss()
    }
}
//#Preview {
//    @EnvironmentObject var database:Database
//    ClothesScreen(clothes: $database.clothes)
//}


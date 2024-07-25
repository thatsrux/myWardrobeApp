//
//  ClothesScreen.swift
//  myWardrobe
//
//  Created by Studente on 02/07/24.
//

import SwiftUI
import Firebase

struct ClothesScreen: View {
    @State var isPresenting: Bool = false
    @State var uiImage: UIImage?
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var isInfoClothScreenActive = false
    @State private var isEditClothScreenActive = false
    
    @State private var loading = false
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    @Binding var clothes : [Cloth]
    
    @EnvironmentObject var database:Database
    
    @State private var selectedOption = "icone"
    
    func deleteClothSwipe(at offsets:IndexSet){
        
        guard let index = offsets.first else {
            print("No index available to delete")
            return
        }
        
        guard index >= 0 && index < database.clothes.count else {
            print("Index \(index) out of range")
            return
        }
        
        let clothToDelete = database.clothes[index+1]
        
        Firestore.firestore().collection("Cloth").document(clothToDelete.id.uuidString).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        database.fetchClothes()
        database.fetchCategorie()
    }
    
    var body: some View {
        NavigationStack {
            if loading {
                ProgressView("Elaborazione immagine in corso").frame(maxHeight: .infinity, alignment: .center)
            } else {
                if searchIsActive {
                    List {
                        ForEach(database.clothes) { cloth in
                            if cloth.nome.lowercased().contains(searchText.lowercased()) {
                                NavigationLink(destination: InfoClothScreen(cloth: cloth)) {
                                    SingleClothList(cloth: cloth)
                                }
                            }
                        }.onDelete(perform: deleteClothSwipe)
                    }
                }
                else {
                    if selectedOption == "elenco" {
                        ClothesList()
                    } else {
                        ClothesGrid()
                    }
                }
            }
            Spacer()
                .navigationTitle("I tuoi capi")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Menu() {
                            Button(action: {
                                isPresenting = true
                                sourceType = .photoLibrary
                            }) {
                                Text("Scegli foto")
                                Image(systemName: "photo.on.rectangle")
                            }
                            
                            Button(action: {
                                isPresenting = true
                                sourceType = .camera
                            }) {
                                Text("Scatta foto")
                                Image(systemName: "camera")
                            }
                        }
                    label:{
                        Image(systemName: "camera")
                    }
                        
                        Menu() {
                            Picker(selection: $selectedOption, label: Text("Options")) {
                                HStack{
                                    Text("Icone")
                                    Image(systemName: "square.grid.2x2")
                                }.tag("icone")
                                
                                HStack{
                                    Text("Elenco")
                                    Image(systemName: "list.bullet")
                                }.tag("elenco")
                            }
                            
                            Divider()
                            Button(action: {
                                for cloth in database.clothes{
                                    Firestore.firestore().collection("Cloth").document(cloth.id.uuidString).delete() { err in
                                        if let err = err {
                                            print("Error removing document: \(err)")
                                        } else {
                                            print("Document successfully removed!")
                                        }
                                    }
                                }
                                database.fetchClothes()
                                database.fetchCategorie()
                            }) {
                                Text("Svuota")
                                Image(systemName: "trash")
                            }
                        }
                    label:{
                        Image(systemName: "ellipsis.circle")
                    }
                    }
                }
                .searchable(text: $searchText, isPresented: $searchIsActive, prompt: "Cerca capo")
                .sheet(isPresented: $isPresenting){
                    ImagePicker(uiImage: $uiImage, isPresenting:  $isPresenting, sourceType: $sourceType)
                        .onDisappear {
                            if uiImage != nil {
                                isInfoClothScreenActive = true
                                loading = true
                            }
                        }
                }
            
                .navigationDestination(isPresented: $isInfoClothScreenActive) {
                    if uiImage != nil {
                        InfoClothScreen(image: uiImage!)
                            .onDisappear {
                                uiImage = nil
                                isInfoClothScreenActive = false
                            }
                            .onAppear {
                                loading = false
                            }
                    }
                }
        }
    }
}


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
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    @Binding var clothes : [Cloth]
    
    @EnvironmentObject var database:Database
    
    @State private var selectedOption = "icone"
    
    
    func deleteCloth(cloth:Cloth){
        Firestore.firestore().collection("Cloth").document(cloth.id.uuidString).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        database.fetchClothes()
        database.fetchCategorie()
    }
    
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
            
            if selectedOption == "elenco" {
                List {
                    ForEach(database.categorie.keys.sorted(), id: \.self){ category in
                        Section(header: Text(category).font(.headline)){
                            ForEach(database.categorie[category]!) { cloth in
                                NavigationLink(destination: InfoClothScreen(cloth: cloth)) {
                                    HStack {
                                        VStack{
                                            Image(uiImage: (cloth.image?.toImage())!)
                                                .resizable()
                                                .scaledToFit()
                                                .clipped()
                                                .frame(width:100,height:100)
                                            HStack{
                                                Circle().fill(cloth.mainColor.toColor()).frame(width: 20, height: 20)
                                                Circle().fill(cloth.secondColor.toColor()).frame(width: 20, height: 20)
                                                Circle().fill(cloth.thirdColor.toColor()).frame(width: 20, height: 20)
                                            }.padding(.bottom,10)
                                        }
                                        
                                        Spacer().frame(width: 30, height: 100)
                                        
                                        Text("\(cloth.nome) - \(cloth.taglia)")
                                    }
                                }
                            }.onDelete(perform: deleteClothSwipe)
                            
                        }
                    }
                }
                
                
                
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible(), alignment: .top), GridItem(.flexible(), alignment: .top)], spacing: 10) {
                        ForEach(database.categorie.keys.sorted(), id: \.self){ category in
                            Section(header: Text(category).font(.headline)){
                                ForEach(database.categorie[category]!, id: \.self) { cloth in
                                    NavigationLink(destination: InfoClothScreen(cloth: cloth)) {
                                        VStack{
                                            VStack {
                                                Image(uiImage: (cloth.image?.toImage())!)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .clipped()
                                                    .cornerRadius(10)
                                                HStack{
                                                    Circle().fill(cloth.mainColor.toColor()).frame(width: 20, height: 20)
                                                    if cloth.colorsNum > 1 {
                                                        Circle().fill(cloth.secondColor.toColor()).frame(width: 20, height: 20)
                                                        if cloth.colorsNum > 2 {
                                                            Circle().fill(cloth.thirdColor.toColor()).frame(width: 20, height: 20)
                                                        }
                                                    }
                                                }
                                                Text("\(cloth.nome) - \(cloth.taglia)").padding(.bottom,10)
                                            }
                                            
                                            .contextMenu(menuItems: {
                                                Button("Elimina", role: .destructive, action: {
                                                    deleteCloth(cloth: cloth)
                                                })
                                            })
                                        }.frame(width: 150, height: 200)
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .shadow(radius: 5)
                                        
                                    }
                                }
                                
                            }
                        }.padding(.bottom,20)
                    }
                    .padding()
                }
                
            }
            
            Spacer()
                .navigationTitle("My Wardrobe")
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
                        .onDisappear{
                            isInfoClothScreenActive = true
                        }
                    
                }
            
                .navigationDestination(isPresented: $isInfoClothScreenActive){
                    if uiImage != nil {
                        InfoClothScreen(image: uiImage!)
                    }
                }
                .navigationDestination(isPresented: $isEditClothScreenActive){
                    EditClothScreen()
                }
        }
    }
}

//#Preview {
//    @EnvironmentObject var database:Database
//    ClothesScreen(clothes: $database.clothes)
//}


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
    private var category: Categoria
    
    @State private var isInfoClothScreenActive = false
    @State private var isEditClothScreenActive = false
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    @EnvironmentObject var database:Database
    
    @State private var selectedOption = "icone"
    
    init(category: Categoria) {
        self.category = category
    }
    
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
            if searchIsActive {
                List {
                    ForEach(database.categorie[category.rawValue]!) { cloth in
                        if cloth.nome.lowercased().contains(searchText.lowercased()) {
                                HStack {
                                    VStack{
                                        Image(uiImage: (cloth.image?.toImage())!)
                                            .resizable()
                                            .scaledToFit()
                                            .clipped()
                                            .frame(width:100,height:100)
                                        HStack{
                                            Circle().fill(cloth.mainColor.toColor()).frame(width: 20, height: 20).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                                            if cloth.colorsNum > 1 {
                                                Circle().fill(cloth.secondColor.toColor()).frame(width: 20, height: 20).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                                                if cloth.colorsNum > 2 {
                                                    Circle().fill(cloth.thirdColor.toColor()).frame(width: 20, height: 20).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                                                }
                                            }
                                        }.padding(.bottom,10)
                                    }
                                    
                                    Spacer().frame(width: 30, height: 100)
                                    
                                    VStack(spacing:5){
                                        Text(cloth.nome).frame(maxWidth: .infinity, alignment: .leading)
                                        Text(cloth.taglia).frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    
                                }.onTapGesture {
                                    //var outfit = Outfit(cloth)
                                    print(cloth.nome)
                                }
                            
                        }
                    }.onDelete(perform: deleteClothSwipe)
                    
                }
            }
            else {
                if selectedOption == "elenco" {
                    List {
                        ForEach(database.categorie[category.rawValue]!) { cloth in
                                        HStack {
                                            VStack{
                                                Image(uiImage: (cloth.image?.toImage())!)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .clipped()
                                                    .frame(width:100,height:100)
                                                HStack{
                                                    Circle().fill(cloth.mainColor.toColor()).frame(width: 20, height: 20).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                                                    if cloth.colorsNum > 1 {
                                                        Circle().fill(cloth.secondColor.toColor()).frame(width: 20, height: 20).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                                                        if cloth.colorsNum > 2 {
                                                            Circle().fill(cloth.thirdColor.toColor()).frame(width: 20, height: 20).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                                                        }
                                                    }
                                                }.padding(.bottom,10)
                                            }
                                            
                                            Spacer().frame(width: 30, height: 100)
                                            
                                            VStack(spacing:5){
                                                Text(cloth.nome).frame(maxWidth: .infinity, alignment: .leading)
                                                Text(cloth.taglia).frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                            
                                        }.onTapGesture {
                                            let outfit = Outfit(cloth:cloth)
                                            print(cloth.nome)
                                            database.outfits.append(outfit)
                                            
                                            print(database.outfits.count)
                                        }
                                    
                                }.onDelete(perform: deleteClothSwipe)
                                
                            }
                    
                    
                    
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible(), alignment: .top), GridItem(.flexible(), alignment: .top)], spacing: 10) {
                            ForEach(database.categorie[category.rawValue]!) { cloth in
                                            VStack{
                                                VStack {
                                                    Image(uiImage: (cloth.image?.toImage())!)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .clipped()
                                                        .cornerRadius(10)
                                                    HStack{
                                                        Circle().fill(cloth.mainColor.toColor()).frame(width: 20, height: 20).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                                                        if cloth.colorsNum > 1 {
                                                            Circle().fill(cloth.secondColor.toColor()).frame(width: 20, height: 20).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                                                            if cloth.colorsNum > 2 {
                                                                Circle().fill(cloth.thirdColor.toColor()).frame(width: 20, height: 20).overlay(Circle().stroke(Color.black, lineWidth:0.5))
                                                            }
                                                        }
                                                    }
                                                    Text(cloth.nome)
                                                    Text(cloth.taglia)
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
                                                .onTapGesture {
                                                    //var outfit = Outfit(cloth)
                                                    print(cloth.nome)
                                                }
                                        
                                    }
                                    
                                }
                            }.padding(.bottom,20)
                        }
            }
            Spacer()
                .navigationTitle("My Wardrobe")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        
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
    
    static func save(outfits: [Outfit]){
        
    }
}

//#Preview {
//    @EnvironmentObject var database:Database
//    ClothesScreen(clothes: $database.clothes)
//}


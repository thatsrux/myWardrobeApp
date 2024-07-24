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
    @Binding var category: Categoria
    @Binding var shirtToAdd:Cloth?
    @Binding var trousersToAdd:Cloth?
    @Binding var shoesToAdd:Cloth?
    
    
    @State private var selectedOption = "icone"
    
    //    init(category: Categoria) {
    //        self.category = category
    //    }
    
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
                    ForEach(database.categorie[category.rawValue]!) { cloth in
                        SingleClothList(cloth: cloth)
                            .onTapGesture {
                            if cloth.categoria == .tshirt{
                                shirtToAdd = cloth
                                onDismiss?(shirtToAdd!)
                            }
                            else if cloth.categoria == .pantalone{
                                trousersToAdd = cloth
                                onDismiss?(trousersToAdd!)
                            }
                            else if cloth.categoria == .scarpe{
                                shoesToAdd = cloth
                                onDismiss?(shoesToAdd!)
                            }
                            
                            dismiss()
                        }
                        
                    }.onDelete(perform: deleteClothSwipe)
                    
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(database.categorie[category.rawValue]!) { cloth in
                            SingleClothGrid(cloth: cloth)
                                .onTapGesture {
                                    if cloth.categoria == .tshirt{
                                        shirtToAdd = cloth
                                        onDismiss?(shirtToAdd!)
                                    }
                                    else if cloth.categoria == .pantalone{
                                        trousersToAdd = cloth
                                        onDismiss?(trousersToAdd!)
                                    }
                                    else if cloth.categoria == .scarpe{
                                        shoesToAdd = cloth
                                        onDismiss?(shoesToAdd!)
                                    }
                                    
                                    dismiss()
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
//#Preview {
//    @EnvironmentObject var database:Database
//    ClothesScreen(clothes: $database.clothes)
//}


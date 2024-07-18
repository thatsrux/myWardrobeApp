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
    
    func deleteCloth(at offsets: IndexSet){
        clothes.remove(atOffsets: offsets)
        InfoClothScreen.save(clothes: clothes)
    }
    
    var groupedClothes: [String: [Cloth]] {
                    Dictionary(grouping: clothes, by: { $0.categoria })
                }
    
    var body: some View {
        NavigationStack {

            if selectedOption == "elenco" {
                List {
                    ForEach(database.clothes, id: \.id) { cloth in
                                NavigationLink(destination: InfoClothScreen(cloth: cloth)) {
                                    HStack {
                                        Image(uiImage: (cloth.image?.toImage())!)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width:100,height:100)
                                            .clipped()
                                            .cornerRadius(10)
                                    }
                                }
                            }
                    }
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                ForEach(database.clothes, id: \.id) { cloth in
                                    NavigationLink(destination: InfoClothScreen(cloth: cloth)) {
                                        VStack {
                                            Image(uiImage: (cloth.image?.toImage())!)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width:150,height:150)
                                                .clipped()
                                                .cornerRadius(10)
                                            
                                            Text("\(cloth.nome) - \(cloth.taglia)")
                                        }
                                        .background(Color.white)
                                        .cornerRadius(15)
                                        .shadow(radius: 5)
                                        .padding(.bottom, 10)
                                    }
                                }
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

#Preview {
    ClothesScreen(clothes: .constant([Cloth(image: UIImage(named: "juve1")!),Cloth(image: UIImage(named: "gucci")!),Cloth(image: UIImage(named: "gucci2")!),Cloth(image: UIImage(named: "madrid")!)]))
}

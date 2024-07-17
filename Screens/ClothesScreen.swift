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
        
    func deleteCloth(at offsets: IndexSet){
        clothes.remove(atOffsets: offsets)
        InfoClothScreen.save(clothes: clothes)
    }
    
    
    
    var body: some View {
        NavigationStack {
            Text("T-Shirt")
            ScrollView(.horizontal,showsIndicators: false){
                HStack(spacing:20){
                    ForEach(database.clothes, id: \.id) { cloth in
                        NavigationLink(destination: InfoClothScreen(cloth: cloth,clothes: $clothes)){
                            Image(uiImage: (cloth.image?.toImage())!)
                                .resizable()
                                .frame(maxWidth: 200,maxHeight: 200)
                        }
                    }
                }.padding()
                    .onAppear{
                        database.fetchClothes()
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
                Button {
                        isInfoClothScreenActive = true
                    print(clothes[0].mainColor.red.description)
                    print(clothes[0].mainColor.red.description.CGFloatValue()!)
                    }
                    
                label: {
                    Image(systemName: "plus.circle")
                }
                
                Button {
                        isEditClothScreenActive = true
                        clothes.removeAll()
                }
                label: {
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
                    InfoClothScreen(image: uiImage!, clothes: $clothes)
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

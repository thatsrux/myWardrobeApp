//
//  ClothesScreen.swift
//  myWardrobe
//
//  Created by Studente on 02/07/24.
//

import SwiftUI

struct ClothesScreen: View {
    @State var isPresenting: Bool = false
    @State var uiImage: UIImage?
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var isAddClothScreenActive = false
    @State private var isEditClothScreenActive = false
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    @Binding var clothes : [Cloth]
    
    var body: some View {
        NavigationStack {
            List{
                ForEach($clothes, id: \.id) {
                    $cloth in
                    Image(uiImage: UIImage(data: cloth.image)!)
                }
            }
        }
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
                    isAddClothScreenActive = true
                }
                
            label: {
                Image(systemName: "plus.circle")
            }
                Button {
                    isEditClothScreenActive = true
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
                    isAddClothScreenActive = true
                }
            
        }
        
        .navigationDestination(isPresented: $isAddClothScreenActive){
            if uiImage != nil {
                AddClothScreen(image: uiImage!)
            }
        }
        .navigationDestination(isPresented: $isEditClothScreenActive){
            EditClothScreen()
        }
    }
}

#Preview {
    ClothesScreen(clothes: .constant([Cloth(image: UIImage(named: "juve1")!),Cloth(image: UIImage(named: "gucci")!),Cloth(image: UIImage(named: "gucci2")!),Cloth(image: UIImage(named: "madrid")!)]))
}

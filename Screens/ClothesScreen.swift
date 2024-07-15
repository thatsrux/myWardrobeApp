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
    
    //@ObservedObject var classifier = ImageClassifier()
    
    @State private var isAddClothScreenActive = false
    @State private var isEditClothScreenActive = false
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    let layout = [
        GridItem(.adaptive(minimum: 150, maximum: 300)),
    ]
    
    private var itemsNum = 10
    
    var body: some View {
        NavigationStack {
            VStack{
                ScrollView {
                    LazyVGrid(columns: layout) {
                        ForEach(0...itemsNum, id: \.self) {_ in
                            Text("I tuoi capi")
                                .frame(width: 150, height: 60)
                                .padding(EdgeInsets(top: 120, leading: 0, bottom: 0, trailing: 0))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                    .stroke(lineWidth: 3)
                                    .frame(width: 150, height: 180)
                                )
                        }
                    }
                }
                Spacer()
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
                        print("A")
                    }
                    
                label: {
                    Image(systemName: "plus.circle")
                }
                    Button {
                        isEditClothScreenActive = true
                        print("B")
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
}

#Preview {
    ClothesScreen()
}

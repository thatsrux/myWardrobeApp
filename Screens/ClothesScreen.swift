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
    
    @State private var isInfoClothScreenActive = false
    @State private var isEditClothScreenActive = false
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    @Binding var clothes : [Cloth]
    
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
            
            //            ScrollView(.horizontal,showsIndicators: false){
            //                HStack(spacing:20){
            //                    ForEach($clothes, id: \.id) { $cloth in
            //                        NavigationLink(destination: InfoClothScreen(cloth: cloth, clothes: $clothes)){
            //                            Image(uiImage: UIImage(data: cloth.image)!)
            //                                .resizable()
            //                                .frame(maxWidth: 200,maxHeight: 200)
            //                        }
            //
            //                    }
            //                }.padding()
            //            }
            if selectedOption == "elenco" {
                List {
                    ForEach(groupedClothes.keys.sorted(), id: \.self) { category in
                        Section(header: Text(category).font(.headline)) {
                            ForEach(groupedClothes[category]!, id: \.id) { cloth in
                                NavigationLink(destination: InfoClothScreen(cloth: cloth, clothes: $clothes)) {
                                    HStack {
                                        Image(uiImage: UIImage(data: cloth.image)!)
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(groupedClothes.keys.sorted(), id: \.self) { category in
                            Section(header: Text(category).font(.headline)) {
                                ForEach(groupedClothes[category]!, id: \.id) { cloth in
                                    NavigationLink(destination: InfoClothScreen(cloth: cloth, clothes: $clothes)) {
                                        VStack {
                                            Image(uiImage: UIImage(data: cloth.image)!)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 150, height: 150)
                                                
                                            Text(cloth.nome)
                                        }
                                        .background(Color.white)
                                        .cornerRadius(15)
                                        .shadow(radius: 5)
                                        .padding(.bottom, 10)
                                    }
                                }
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
                                clothes.removeAll()
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


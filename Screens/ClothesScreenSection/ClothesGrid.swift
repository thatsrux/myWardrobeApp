//
//  SwiftUIView.swift
//  myWardrobe
//
//  Created by Studente on 23/07/24.
//

import SwiftUI
import Firebase

let columns = [
    GridItem(.adaptive(minimum: 160))
]

struct ClothesGrid: View {
    
    @EnvironmentObject var database:Database
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(database.categorie.keys.sorted(), id: \.self){ category in
                    Section(header: Text(categoriePlurale[Categoria(rawValue: category)!]!).font(.headline)){
                        ForEach(database.categorie[category]!, id: \.self) { cloth in
                            NavigationLink(destination: InfoClothScreen(cloth: cloth)) {
                                SingleClothGrid(cloth: cloth)
                            }
                        }
                        
                    }
                }.padding(.bottom,20)
            }
            .padding()
        }
    }
    
}


struct SingleClothGrid: View {
    
    @EnvironmentObject var database:Database
    private let cloth: Cloth
    
    init(cloth: Cloth) {
        self.cloth = cloth
    }
    
    var body: some View {
        VStack{
            VStack {
                Image(uiImage: (cloth.image?.toImage())!)
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .cornerRadius(10)
                    .padding(5)
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
                    .padding(5)
                if cloth.taglia != .NA {
                    Text(cloth.taglia.rawValue)
                }
            }
        }.frame(width: 150, height: 200)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .contextMenu(menuItems: {
                Button("Elimina", role: .destructive, action: {
                    deleteCloth(cloth: cloth)
                })
            })
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
}

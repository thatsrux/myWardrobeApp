//
//  ContentView.swift
//  myWardrobe
//
//  Created by Studente on 02/07/24.
//

import SwiftUI

struct ContentView: View {
    @State var selection = 0
    var body: some View {
            TabView(selection: $selection) {
                OutfitScreen(stato: "prova",nOutfits: ["primo","secondo"])
                    .tabItem {
                        Label ("Galleria Outfit", systemImage: "tshirt")
                        .accentColor(.primary)}
                    .tag (0)
                
                ClothesScreen()
                    .tabItem {
                        Label ("Guardaroba", systemImage: "hanger")
                        .accentColor(.primary)}
                    .tag (2)
                AdvicesScreen()
                    .tabItem{
                        Label("Consigli", systemImage: "globe.europe.africa.fill")
                            .accentColor(.primary)
                    }.tag(1)
                }
        }
}


struct Vestito: Identifiable, Codable {
    var id = UUID()
    var nome: String?
    var nomeImmagine: String
    var tipoVestito: String
//    var stile: String
//    var colore1: Color
//    var colore2: Color?
//    var colore3: Color?
}

#Preview {
    ContentView()
}

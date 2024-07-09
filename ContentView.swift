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
                OutfitScreen(stato:[Outfit(shirt: Vestito(nomeImmagine: "", tipoVestito: ""), trousers: Vestito(nomeImmagine: "", tipoVestito: ""), shoes: Vestito(nomeImmagine: "", tipoVestito: ""))])
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




#Preview {
    ContentView()
}

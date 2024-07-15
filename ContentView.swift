//
//  ContentView.swift
//  myWardrobe
//
//  Created by Studente on 02/07/24.
//

import SwiftUI

struct ContentView: View {
    @State var clothes : [Cloth] = ([Cloth(image: UIImage(named: "juve1")!),Cloth(image: UIImage(named: "gucci")!),Cloth(image: UIImage(named: "gucci2")!),Cloth(image: UIImage(named: "madrid")!)])
    
    @State var selection = 0
    
    var body: some View {
            TabView(selection: $selection) {
                OutfitScreen(outfits:[Outfit(shirt: Cloth(nome: "", categoria: ""), trousers: Cloth(nome: "", categoria: ""), shoes: Cloth(nome: "", categoria: ""))])
                    .tabItem {
                        Label ("Galleria Outfit", systemImage: "tshirt")
                        .accentColor(.primary)}
                    .tag (0)
                
                ClothesScreen(clothes: $clothes)
                    .tabItem {
                        Label ("Guardaroba", systemImage: "hanger")
                        .accentColor(.primary)}
                    .tag (2)
                AdvicesScreen()
                    .tabItem{
                        Label("Consigli", systemImage: "globe.europe.africa.fill")
                            .accentColor(.primary)
                    }.tag(1)
            }.onAppear(){
                if let data = UserDefaults.standard.object(forKey: "CLOTHES"){
                    do {
                        let decoder = JSONDecoder()
                        let clo = try decoder.decode([Cloth].self, from: data as! Data)
                        clothes = clo
                    } catch {
                        print("Impossibile effettuare la decodifica \(error)")
                    }
                }
            }
        }
}




#Preview {
    ContentView()
}

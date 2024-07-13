//
//  InfoOutfitScreen.swift
//  myWardrobe
//
//  Created by Studente on 09/07/24.
//

import SwiftUI

struct InfoOutfitScreen: View {
    
    var outfits:[Outfit] = []
    @State var outfit:Outfit
    @State var index:Int
    
    init(outfits: [Outfit],index:Int){
        self.outfits = outfits
        self.index = index
        outfit = outfits[index]
    }
    var body: some View {
        Text("""
Outfit selezionato (indice \(index))
\(outfits[index].shirt.nome)
""")
    }
}

#Preview {
    InfoOutfitScreen(outfits: [Outfit(shirt: Cloth(nome: " ", categoria: " "), trousers: Cloth(nome: " ", categoria: " "), shoes:Cloth(nome: " ", categoria: " "))],index: 0)
}

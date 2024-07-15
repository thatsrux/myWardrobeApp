//
//  InfoOutfitScreen.swift
//  myWardrobe
//
//  Created by Studente on 09/07/24.
//

import SwiftUI

struct InfoOutfitScreen: View {
    
    var outfits = [Outfit]()
    var index:Int
    var outfit:Outfit
    
    init(outfits: [Outfit],index:Int){
        self.outfits = outfits
        self.index = index
        self.outfit = outfits[index]
    }
    var body: some View {
        Text("""
Outfit selezionato (indice \(index))
\(outfits[index].shirt.categoria): \(outfits[index].shirt.nome)
\(outfits[index].trousers.categoria): \(outfits[index].trousers.nome)
\(outfits[index].shoes.categoria): \(outfits[index].shoes.nome)
""")
    }
}
/*
#Preview {
    InfoOutfitScreen(outfits: [Outfit(shirt: Cloth(nome: " ", categoria: " "), trousers: Cloth(nome: " ", categoria: " "), shoes:Cloth(nome: " ", categoria: " "))],index: 0)
}
*/

//
//  InfoOutfitScreen.swift
//  myWardrobe
//
//  Created by Studente on 09/07/24.
//

import SwiftUI

struct InfoOutfitScreen: View {
    
    var outfits:[Outfit] = []
    @State var stato:[Outfit]
    
    init(outfits: [Outfit]){
        self.outfits = outfits
        stato = [Outfit(shirt: Vestito(nomeImmagine: " ", tipoVestito: " "), trousers: Vestito(nomeImmagine: " ", tipoVestito: " "), shoes:Vestito(nomeImmagine: " ", tipoVestito: " "))]
    }
    var body: some View {
        Text("""
Hai selezionato l'outfit:

numero di outfit: \(outfits.count)
""")
    }
}

#Preview {
    InfoOutfitScreen(outfits: [Outfit(shirt: Vestito(nomeImmagine: " ", tipoVestito: " "), trousers: Vestito(nomeImmagine: " ", tipoVestito: " "), shoes:Vestito(nomeImmagine: " ", tipoVestito: " "))])
}

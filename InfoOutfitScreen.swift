//
//  InfoOutfitScreen.swift
//  myWardrobe
//
//  Created by Studente on 09/07/24.
//

import SwiftUI

struct InfoOutfitScreen: View {
    @State var stato:Outfit
    
    init(stato: Outfit){
        self.stato = stato
    }
    var body: some View {
        Text("""
Hai selezionato l'outfit:
\(stato.shirt.tipoVestito): \(stato.shirt.nomeImmagine)
\(stato.trousers.tipoVestito): \(stato.trousers.nomeImmagine)
\(stato.shoes.tipoVestito): \(stato.shoes.nomeImmagine)
""")
    }
}

#Preview {
    InfoOutfitScreen(stato: Outfit(shirt: Vestito(nomeImmagine: " ", tipoVestito: " "), trousers: Vestito(nomeImmagine: " ", tipoVestito: " "), shoes:Vestito(nomeImmagine: " ", tipoVestito: " ")))
}

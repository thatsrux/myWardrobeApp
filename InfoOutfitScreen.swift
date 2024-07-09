//
//  InfoOutfitScreen.swift
//  myWardrobe
//
//  Created by Studente on 09/07/24.
//

import SwiftUI

struct InfoOutfitScreen: View {
    @State var stato:Int
    
    init(stato: Int){
        self.stato = stato
    }
    var body: some View {
        Text("Hai selezionato l'outfit numero\(stato)")
    }
}

#Preview {
    InfoOutfitScreen(stato: 0)
}
